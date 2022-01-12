### INSTALL ADDITIONAL MODULE(S).....

$moduleName = "SqlServer"
$modules = Get-InstalledModule | Where-Object { $_.Name -eq $moduleName }
if ($modules.Count -eq 0) {
    Write-Host "Installing module $($moduleName)....." -ForegroundColor Yellow
    Install-Module -Name $moduleName -AllowClobber -Confirm:$False -Force
}

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
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()][string] $DatabaseName,
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()][string] $ServerName,
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()][int] $ServerPort,
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()][string]$DatatinoDevOpsGitUrl,
        [string]$DatatinoDevOpsGitBranch = "master",
        [string]$DatatinoDevOpsPAT = $null,
        [string]$Hostname = $null
    )

    if ($null -eq $(docker ps -asq --filter "name=$ServerName")) {
        
        $characterList = 'a'..'z' + 'A'..'Z' + '0'..'9' + '!@#$%^&*'.ToCharArray()

        Write-Host "Setup server(s)....." -ForegroundColor Yellow
        $(docker run `
                --cap-add SYS_PTRACE `
                -e "ACCEPT_EULA=1" `
                -e "MSSQL_SA_PASSWORD=$(-join(Get-Random $characterList -Count 20))" `
                -p ${ServerPort}:1433 `
                --restart unless-stopped `
                -d `
                --name $ServerName `
                mcr.microsoft.com/mssql/server > $null 2>&1) 

        Write-Host "Starting server(s): $Hostname....." -ForegroundColor Blue
        Invoke-RetryCommand `
            -ScriptBlock {
            Invoke-Sqlcmd `
                -ServerInstance "$Hostname,${ServerPort}" `
                -Database "master" `
                -Query "IF NOT EXISTS (SELECT * FROM sys.databases WHERE [name] = '$DatabaseName') BEGIN CREATE DATABASE [$DatabaseName] END;" `
                -Username "sa" `
                -Password "$(docker exec $ServerName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" `
        } `
            -RetryCount 10

        Write-Host "Setup Datatino Tool(s)....." -ForegroundColor Yellow

        $devOpsUrl = $DatatinoDevOpsGitUrl
        $devOpsBranch = $DatatinoDevOpsGitBranch
        if ($null -ne $DatatinoDevOpsPAT) {
            $reg = [Regex]::new('(?<=https://)(.+@+?)(?=.+)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
            $devOpsUrl = $reg.Replace($devOpsUrl, [System.String]::Empty)

            $devOpsUrl = $devOpsUrl.Insert("https://".Length, "$($DatatinoDevOpsPAT)@")
        }

        $(git clone -b $devOpsBranch $devOpsUrl)

        Set-Location "$(Split-Path $devOpsUrl -Leaf)/Datatino.Model"

        '{ 
            "DatabaseConnectionString": "' + "Data Source=$Hostname,${ServerPort};Initial Catalog=${DatabaseName};User ID=sa;Password=$(docker exec $ServerName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" + '"
        }' | Out-File ".database"
        
        $(dotnet tool install --global dotnet-ef)
        $(dotnet ef migrations add SecondVersion-1.0.1)
        $(dotnet ef database update)

        foreach ($script in @("./Views/Views.sql", "./Sql/upsert_statements.sql")) {
            Invoke-Sqlcmd `
                -ServerInstance "$Hostname,${ServerPort}" `
                -Database $DatabaseName `
                -InputFile $script `
                -Username "sa" `
                -Password "$(docker exec $ServerName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" `
                -Verbose
        }

        Set-Location ../..

        Remove-Item -Path "./$(Split-Path $devOpsUrl -Leaf)" -Force -Recurse        
        
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

    $dependencies = $($dependencies | ForEach-Object {
            if ($null -ne $_) {
                return $(Get-ChildItem -Path $_).FullName
            }
        })

    $resultSet = @()
    if ($null -ne $dependencies) {
        foreach ($dependency in $dependencies) {
            $resultSet += $(Get-Dependencies $dependency)
        }
    }

    $resultSet += $dependencies
    return $resultSet
}