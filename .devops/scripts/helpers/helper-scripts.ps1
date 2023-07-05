### INSTALL ADDITIONAL MODULE(S).....
$moduleList = @("SqlServer")
$moduleList | ForEach-Object {
    $module = $_
    $modules = Get-InstalledModule | Where-Object { $_.Name -eq $module }
    if ($modules.Count -eq 0) {
        Write-Host "Installing module $($module)....." -ForegroundColor Yellow
        Install-Module -Name $module -RequiredVersion 21.1.18256 -AllowClobber -Confirm:$False -Force
    }
}

# Function to retry any command within an `Script Block` i.e., {}. 
# The amount of reties are by default 3 times with an interval of 30 seconds.
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

# Create a containerized MSSQL server and database when doesn't exists.
# The function initiates and starts the container, that in turn gets populated with Datatino (Entity Framework; different repository) artifacts to
# allow UPSERT functionality when a script is ran with needed. Additionally, Schemas and configuration settings will also be 
# imported into the database.
function Install-MssqlContainer {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()][string] $DatabaseName,
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()][string] $ServerName,
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()][int] $ServerPort,
        [parameter(Mandatory, ValueFromPipeline)][ValidateNotNullOrEmpty()][string]$DatatinoDevOpsGitRefUrl,
        [string]$DatatinoDevOpsGitBranch = "master",
        [string]$DatatinoDevOpsPAT = $null,
        [string]$Hostname = $null
    )

    $currentLocation = Get-Location
    if ($null -eq $(docker ps -asq --filter "name=$ServerName")) {
        
        try {
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
                    mcr.microsoft.com/mssql/server:2022-latest > $null 2>&1) 

            Write-Host "Starting server(s): $Hostname....." -ForegroundColor Blue
            $password = "$(docker exec $ServerName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')"
            Invoke-RetryCommand `
                -ScriptBlock {
                Invoke-Sqlcmd `
                    -ServerInstance "$Hostname,${ServerPort}" `
                    -Database "master" `
                    -Query "IF NOT EXISTS (SELECT * FROM sys.databases WHERE [name] = '$DatabaseName') BEGIN CREATE DATABASE [$DatabaseName] END;" `
                    -Username "sa" `
                    -Password $password `
            } `
                -RetryCount 10

            Write-Host "Setup Datatino Tool(s)....." -ForegroundColor Yellow

            $devOpsUrl = $DatatinoDevOpsGitRefUrl
            $devOpsBranch = $DatatinoDevOpsGitBranch
            $devOpsDirectory = "__$(Split-Path $devOpsUrl -Leaf)"

            if ((Test-Path -Path "../$($devOpsDirectory)") -eq $false ) {
                $devOpsUrl = $devOpsUrl.Replace(" ", "%20")
                $reg = [Regex]::new('(?<=https://)(.+@+?)(?=.+)', [System.Text.RegularExpressions.RegexOptions]::Singleline)
                $devOpsUrl = $reg.Replace($devOpsUrl, [System.String]::Empty)

                $devOpsUrl = $devOpsUrl.Insert("https://".Length, "$($DatatinoDevOpsPAT)@")

                $(git clone -b $devOpsBranch $devOpsUrl "../$($devOpsDirectory)")
            }

            Set-Location "../$($devOpsDirectory)/src/Datatino.Model" -ErrorAction Stop

            '{ "DatabaseConnectionString": "' + "Data Source=$Hostname,${ServerPort};Initial Catalog=${DatabaseName};TrustServerCertificate=true;Encrypt=false;User ID=sa;Password=${password}" + '" }' | Out-File ".database"

            # Install Datatino configuration tables into container
            $(dotnet tool install --global --version 6.0 dotnet-ef)
            $(dotnet ef migrations add SecondVersion-1.0.1)
            $(dotnet ef database update)

            foreach ($script in @("./Views/Views.sql", "./Sql/upsert_statements.sql")) {
                Invoke-Sqlcmd `
                    -ServerInstance "$Hostname,${ServerPort}" `
                    -Database $DatabaseName `
                    -InputFile $script `
                    -Username "sa" `
                    -Password $password `
                    -Verbose
            }

            Set-Location $currentLocation
            
            Remove-Item -Path "../$($devOpsDirectory)" -Force -Recurse        
        
            Write-Host "Finished setting up server(s)..... `n" -ForegroundColor Green
        }
        catch {
            if ($null -ne $(docker ps -asq --filter "name=$ServerName")) {
                $(docker container stop $ServerName > $null 2>&1)
                $(docker container rm $ServerName > $null 2>&1)
            }

            throw "$($_.exception.message)"
        }
    }
}

# Determine the dependencies of any Notebook recussively, meaning that within a Notebook different dependencies will be detected.
# This continues until a Notebook is hid without any dependencies.
# !! KEEP IN MIND THAT THERE IS NO CHECK ON INFINIT LOOPS!!
function Get-Dependencies {
    [CmdletBinding()]
    param (
        [String] $ScriptPath
    )
    
    $reg = [Regex]::new('(?<=dependencies.+json).+(?=```)', [System.Text.RegularExpressions.RegexOptions]::Singleline + [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $cells = (Get-Content -Raw -Path $ScriptPath | ConvertFrom-Json).cells
    $markdowns = $cells | Where-Object { $_.cell_type -eq "markdown" -and $reg.IsMatch($_.source) }
    $dependencies = ($markdowns | ForEach-Object { $reg.Match($_.source).Value.Trim() } | ConvertFrom-Json)."depends-on"

    $dependencies = $($dependencies | ForEach-Object {
            if ($null -ne $_) {
                try {                    
                    return $(Get-ChildItem -Path $_ -ErrorAction Stop).FullName
                }
                catch {
                    throw "Failed to get dependencies for: $($ScriptPath). Reason: $($_)"
                }
                
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

function Set-LocalIPAddress {
    return ([System.Net.DNS]::GetHostAddresses((hostname)) |
        Where-Object { $_.AddressFamily -eq "InterNetwork" } |  
        Select-Object IPAddressToString)[0].IPAddressToString
}