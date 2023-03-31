Param (
    [String]$SourceDirectory = $env:PWD ?? $(Get-Location),
    [String[]]$ModifiedFiles = $null,
    [String]$DatatinoDevOpsPAT = $null,
    [String]$DatatinoDevOpsGitBranch = "master",
    [String]$DatatinoDevOpsGitRefUrl = "https://VWSCoronaDashboard@dev.azure.com/VWSCoronaDashboard/Corona Dashboard/_git/nl-cdb-be-apis",
    [String]$Hostname = $null, #put your minikube ip address here if running on windows
    [Int32]$Port = 14331
)

### LOAD EXTERNAL SCRIPT(S).....
. "./.devops/scripts/helpers/helper-scripts.ps1"

Write-Host "loaded helper scripts"

### SET VARIABLE(S).....
$databaseName = "dashboard-db"
$serverName = "local-mssql"
$serverPort = $Port

### GET MODIFIED NOTEBOOK(S).....
if (($null -eq $ModifiedFiles) -or ($($ModifiedFiles | Where-Object { $_.Trim() -ne [System.String]::Empty}).Count -eq 0))  {
    $files = $(Get-ChildItem -Path "src/**/*.ipynb" -Recurse).FullName | ForEach-Object { $_ -replace "$($env:PWD ?? [regex]::escape($(Get-Location)))/", '' }
} else {
    $files = $ModifiedFiles
}

Write-Host "gotten modified notebooks"

$notebooks = $files | Where-Object { ($_.Endswith(".ipynb")) -and (Test-Path -LiteralPath $_) -and (-not [System.IO.Path]::GetFileName($_).StartsWith("__")) }

# Recusively get all dependencies within the Notebooks and
# garantee to only have the unique documents to prevent unneccessary duplicate documents
# for futher uses.
$deps = @()
foreach ($notebook in $notebooks) {
    $deps += $(Get-Dependencies $notebook)
    if (!$deps.Contains($notebook)) {
        $deps += $notebook
    }
}

Write-Host "gotten deps for notebooks"

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
    -DatatinoDevOpsGitRefUrl $DatatinoDevOpsGitRefUrl `
    -Hostname $Hostname

### BUILD MSSQL SCRIPT(S).....
if ($notebooks.Count -gt 0) {
    $notebooks | ForEach-Object {
        if (Test-Path $_) {        
            try {
                $scriptPath = [System.IO.Path]::ChangeExtension(
                    $(Join-Path -Path $SourceDirectory -ChildPath (Split-Path $_ -Leaf)), 
                    ".sql"
                )
                $scriptIndex = [System.Array]::IndexOf($notebooks, $_)
                $scriptFileName = "./$($scriptIndex)-$([System.IO.Path]::GetFileName($scriptPath))"  
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
                    "EXEC sp_executesql N'" + $($_.source -replace '^\s*GO\s*$', '' -replace '''', '''''') + "'`n" + ### ESCAPE &apos; WITHIN MSSQL SCRIPTS
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

                # Execute the MSSQL script atleast three times to ensure that the scripts are 
                # re-runnable.
                foreach ($i in 1..3) {
                    Invoke-RetryCommand -RetryCount 0 -ScriptBlock {
                        Invoke-Sqlcmd `
                            -ServerInstance "$Hostname,${serverPort}" `
                            -Database $databaseName `
                            -InputFile $scriptFileName `
                            -Username "sa" `
                            -Password "$(docker exec $serverName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" `
                    }
                }

                Write-Host "Script build successfully! `n" -ForegroundColor Green
            }
            catch {
                $msg = ($_.exception.InnerException ?? $_.exception).Message
                throw $msg
            }
        }
    }
}