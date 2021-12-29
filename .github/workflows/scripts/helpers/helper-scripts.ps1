### INSTALL ADDITIONAL MODULE(S).....
Write-Host "Installing module SqlServer....." -ForegroundColor Yellow
Install-Module -Name SqlServer -AllowClobber -Confirm:$False -Force

function Invoke-RetryCommand {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipeline)] 
        [ValidateNotNullOrEmpty()]
        [scriptblock] $ScriptBlock,
        [int] $RetryCount = 3,
        [int] $TimeoutInSecs = 30,
        [string] $SuccessMessage = "Command executed successfuly!",
        [string] $FailureMessage = "Failed to execute the command"
    )
        
    process {
        $Attempt = 1
        $Flag = $true
        
        do {
            try {
                $PreviousPreference = $ErrorActionPreference
                $ErrorActionPreference = 'Stop'
                Invoke-Command -ScriptBlock $ScriptBlock -OutVariable Result
                $ErrorActionPreference = $PreviousPreference

                # flow control will execute the next line only if the command in the scriptblock executed without any errors
                # if an error is thrown, flow control will go to the 'catch' block
                Write-Verbose "$SuccessMessage `n"
                $Flag = $false
            }
            catch {
                if ($Attempt -gt $RetryCount) {
                    Write-Verbose "$FailureMessage! Total retry attempts: $RetryCount"
                    Write-Error "[Error Message] $($_.exception.message) `n"
                    $Flag = $false
                }
                else {
                    Write-Verbose "[$Attempt/$RetryCount] $FailureMessage. Retrying in $TimeoutInSecs seconds..."
                    Start-Sleep -Seconds $TimeoutInSecs
                    $Attempt = $Attempt + 1
                }
            }
        }
        While ($Flag)
        
    }
}

function Install-MssqlContainer {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()][string] $ContainerName,
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()][int] $ContainerPort,
        [string]$DatatinoDevOpsPAT
    )

    if ($null -eq $(docker ps -asq --filter "name=$ContainerName")) {
        
        Write-Host "Setup server(s)....." -ForegroundColor Yellow
        $(docker run `
            --cap-add SYS_PTRACE `
            -e "ACCEPT_EULA=1" `
            -e "MSSQL_SA_PASSWORD=$(gpg --gen-random --armor 1 14)" `
            -p ${ContainerPort}:1433 `
            --restart unless-stopped `
            -d `
            --name $ContainerName `
            mcr.microsoft.com/mssql/server > /dev/null 2>&1) 

        Write-Host "Starting server(s): $(hostname -i)....." -ForegroundColor Blue
        Invoke-RetryCommand `
            -ScriptBlock {
                Invoke-Sqlcmd `
                    -ServerInstance "$(hostname -i),${ContainerPort}" `
                    -Database "master" `
                    -Query "IF NOT EXISTS (SELECT * FROM sys.databases WHERE [name] = '$ContainerName') BEGIN CREATE DATABASE [$ContainerName] END;" `
                    -Username "sa" `
                    -Password "$(docker exec $ContainerName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" `
            } `
            -RetryCount 10

        Write-Host "Setup Datatino script(s)....." -ForegroundColor Yellow

        $devOpsUrl = "https://kpmg-nl@dev.azure.com/kpmg-nl/VWS-covid19-migration-project/_git/Datatino"
        $devOpsBranch = "topic/add_missing_configurations"
        if ($null -ne $DatatinoDevOpsPAT) { 
            $devOpsUrl = $devOpsUrl.Replace("kpmg-nl@", "$($devOpsPAT)@")
        }

        $(git clone -b $devOpsBranch $devOpsUrl)
        Set-Location Datatino/Datatino.Model

        '{ 
            "DatabaseConnectionString": "' + "Data Source=$(hostname -i),${containerPort};Initial Catalog=${ContainerName};User ID=sa;Password=$(docker exec $ContainerName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" + '"
        }' | Out-File ".database"
        
        $(dotnet tool install --global dotnet-ef)
        $(dotnet ef migrations add SecondVersion-1.0.1)
        $(dotnet ef database update)

        foreach ($script in @("./Views/Views.sql", "./Sql/upsert_statements.sql")) {
            Invoke-Sqlcmd `
                -ServerInstance "$(hostname -i),${containerPort}" `
                -Database $ContainerName `
                -InputFile $script `
                -Username "sa" `
                -Password "$(docker exec $ContainerName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" `
                -Verbose
        }

        Set-Location ../..

        Remove-Item -Path ./Datatino -Force -Recurse        
        
        Write-Host "Finished setting up server(s)..... `n" -ForegroundColor Green
    }
}

function Get-Dependencies {
    [CmdletBinding()]
    param (
        [String] $ScriptPath
    )
    
    $reg = [Regex]::new('(?<=dependencies.+json).+(?=```)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $cells = (Get-Content -Raw -Path $ScriptPath | ConvertFrom-Json).cells
    $markdowns = $cells | Where-Object { $_.cell_type -eq "markdown" -and $reg.IsMatch($_.source.toLower()) }
    $dependencies = ($markdowns | ForEach-Object { $reg.Match($_.source.toLower()).Value.Trim() } | ConvertFrom-Json)."depends-on"

    $resultSet = @()
    if ($null -ne $dependencies) {
        foreach ($dependency in $dependencies) {
            $resultSet += $(Get-Dependencies $dependency)
        }
    }

    $resultSet += $dependencies
    return $resultSet
}