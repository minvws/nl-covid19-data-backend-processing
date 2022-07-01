Param (
    [String]$SourceDirectory = $env:PWD ?? $(Get-Location),
    [String[]]$ModifiedFiles = $($(Get-ChildItem -Path "src/**/*.ipynb" -Recurse).FullName | ForEach-Object { $_ -replace "$($env:PWD ?? [regex]::escape($(Get-Location)))/", '' }),
    [String]$DatatinoDevOpsPAT = $null,
    [String]$DatatinoDevOpsGitBranch = "master",
    [String]$DatatinoDevOpsGitUrl = "https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_git/nl-cdb-be-apis",
    [String]$Hostname = $null #put your minikube ip address here if running on windows
)

### LOAD EXTERNAL SCRIPT(S).....
. "./.github/workflows/scripts/helpers/helper-scripts.ps1"

### SET VARIABLE(S).....
$databaseName = "dashboard-db"
$serverName = "local-mssql"
$serverPort = 14331

### GET MODIFIED NOTEBOOK(S).....
$notebooks = ($ModifiedFiles -Split ' ') | Where-Object { ($_.endswith(".ipynb")) -and (Test-Path -LiteralPath $_)}

$deps = @()
foreach ($notebook in $notebooks) {
    $deps += $(Get-Dependencies $notebook)
    if (!$deps.Contains($notebook)) {
        $deps += $notebook
    }
}

$notebooks = $($deps | Select-Object -Unique | ForEach-Object { return $(Get-ChildItem -Path $_).FullName } | Select-Object -Unique) 

### SETUP DATATINO MOCK CONTAINER(S).....
if ($Hostname.Length -eq 0) {
    $Hostname = $(Set-LocalIPAddress)
}

Install-MssqlContainer `
    -DatabaseName $databaseName `
    -ServerName $serverName `
    -ServerPort $serverPort `
    -DatatinoDevOpsPAT $DatatinoDevOpsPAT `
    -DatatinoDevOpsGitBranch $DatatinoDevOpsGitBranch `
    -DatatinoDevOpsGitUrl $DatatinoDevOpsGitUrl `
    -Hostname $Hostname

### BUILD MSSQL SCRIPT(S).....
if ($notebooks.Count -gt 0) {
    $($notebooks -Split ' ') | ForEach-Object {
        if (Test-Path $_) {        
            try {
                $scriptPath = [System.IO.Path]::ChangeExtension(
                    $(Join-Path -Path $SourceDirectory -ChildPath (Split-Path $_ -Leaf)), 
                    ".sql"
                )
                $scriptIndex = [System.Array]::IndexOf($notebooks, $_)
                $scriptFileName = "$($scriptIndex)-$([System.IO.Path]::GetFileName($scriptPath))"  
                $scriptCodes = (Get-Content -Raw -Path $_ | ConvertFrom-Json).cells | Where-Object { $_.cell_type -eq "code" }  

                Write-Host "$($scriptPath):" -ForegroundColor Blue
                Write-Host "Build script....." -ForegroundColor Yellow

                ### ADD TRANSACTION ENCAPSULATION
                $scriptCodes | ForEach-Object {
                    "SET ANSI_NULLS ON`n" +
                    "GO`n" + 
                    "SET QUOTED_IDENTIFIER ON`n" +
                    "GO`n" +
                    "BEGIN TRY`n" +
                    "BEGIN TRANSACTION CTRAN;`n" +
                    "EXEC sp_executesql N'" + $($_.source -replace '^GO$', '' -replace '''', '''''') + "'`n" + ### ESCAPE &apos; WITHIN MSSQL SCRIPTS
                    "COMMIT TRANSACTION CTRAN;`n" +
                    "END TRY`n" +
                    "BEGIN CATCH`n" +
                    "IF @@TRANCOUNT > 0`n" +
                    "BEGIN`n" +
                    "PRINT '>> ROLLING BACK'`n" +
                    "ROLLBACK TRANSACTION CTRAN; -- The semi-colon is required (at least in SQL 2012)`n" +
                    "END; -- I had to put a semicolon to avoid error near THROW`n" +
                    "THROW`n" +
                    "END CATCH`n" +
                    "GO`n"
                } | Out-File $scriptFileName

                foreach ($i in 1..2) {
                    Invoke-RetryCommand -RetryCount 0 -ScriptBlock {
                        Invoke-Sqlcmd `
                            -ServerInstance "$Hostname,${serverPort}" `
                            -Database $databaseName `
                            -InputFile $scriptFileName `
                            -Username "sa" `
                            -Password "$(docker exec $serverName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" `
                    }
                }

                Write-Host "Script build successfuly! `n" -ForegroundColor Green
            }
            catch {
                throw "$($_.exception.message)"
            }
        }
    }
}