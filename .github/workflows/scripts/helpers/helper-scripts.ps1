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
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()] [string] $ContainerScript,
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()][int] $ContainerPort
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

        Write-Host "Install Flyway tool(s)....." -ForegroundColor Yellow
        $flywayVersion = "8.2.2"
        $flywayInstallPath = "./.flyway"

        if (!(Test-Path "/usr/local/bin/flyway")) {
            $currentLocation = Get-Location
        
            New-Item -Path $flywayInstallPath -ItemType Directory -Force
            Set-Location $flywayInstallPath
            $("wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/$($flywayVersion)/flyway-commandline-$($flywayVersion)-linux-x64.tar.gz | tar xvz && sudo ln -s ``pwd``/flyway-$($flywayVersion)/flyway /usr/local/bin" | sh) 
            Set-Location $currentLocation
        }

        "flyway.url=jdbc:sqlserver://$(hostname -i):$($ContainerPort);databaseName=$($ContainerName)
        flyway.user=sa
        flyway.password=$(docker exec $ContainerName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')
        flyway.baselineDescription=Base Migration
        flyway.baselineOnMigrate=true
        flyway.schemas= VWS,\
                        VWSARCHIVE, \
                        VWSSTAGE, \
                        VWSSTATIC, \
                        VWSINTER, \
                        VWSDEST, \
                        VWSREPORT, \
                        VWSMISC, \
                        VWSANALYTICS, \
                        DATATINO_ORCHESTRATOR_1, \
                        DATATINO_PROTO_1" | Out-File "$($flywayInstallPath)/flyway-$($flywayVersion)/conf/flyway.conf"

        $(flyway migrate)

        Remove-Item -Path "$($flywayInstallPath)/flyway-$($flywayVersion)/conf/flyway.conf" -Force

        Write-Host "Setup Datatino script(s)....." -ForegroundColor Yellow
        Invoke-Sqlcmd `
            -ServerInstance "$(hostname -i),${containerPort}" `
            -Database $ContainerName `
            -InputFile $ContainerScript `
            -Username "sa" `
            -Password "$(docker exec $ContainerName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" `
            -Verbose
        
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