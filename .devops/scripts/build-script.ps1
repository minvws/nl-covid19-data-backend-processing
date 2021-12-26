Param (
    [String]$SourceDirectory = $env:PWD
)

### LOAD EXTERNAL SCRIPT(S).....
. "./deploy/scripts/utils/build-and-release-helpers.ps1"

### SET VARIABLE(S).....
$containerPort = 14331
$containerName = "a1049e34-6129-11ec-90d6-0242ac120003"

### GET MODIFIED NOTEBOOK(S).....
$notebooks = $(git diff HEAD HEAD~ --name-only -R) | Where-Object { $_.endswith(".ipynb") }

### SETUP DATATINO MOCK CONTAINER(S).....
Install-ContainerUnit `
    -ContainerName $containerName `
    -ContainerPort $containerPort `
    -ContainerScript "./deploy/scripts/utils/build-helpers.sql"

### BUILD MSSQL SCRIPT(S).....
$rank = 0
$prevEnv = ''
$notebooks = Get-ChildItem $notebooks | Select-Object FullName, Length, @{ 
    n = 'Directory'; e = { $_.Name -replace '.*(utils|workflows).*', '$1' } 
} |
Sort-Object FileName | Select-Object *, @{
    n = 'Rank'; e = {
        --$rank

        if ($prevEnv -ne $_.Environment) { 
            $rank = 1
            Set-Variable -Scope 1 prevEnv $_.Environment
        }

        Set-Variable -Scope 1 rank $rank
        $rank
    }
}

if ($notebooks.Count -ne 1) {
    [System.Array]::Reverse($notebooks)
}

$notebooks.FullName | ForEach-Object {

    if (Test-Path $_) {        
        try {
            $scriptPath = [System.IO.Path]::ChangeExtension(
                $(Join-Path -Path $SourceDirectory -ChildPath (Split-Path $_ -Leaf)), 
                ".sql"
            )
            $scriptIndex = [System.Array]::IndexOf($notebooks.FullName, $_)
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

            Invoke-RetryCommand -RetryCount 0 -ScriptBlock  {
                Invoke-Sqlcmd `
                    -ServerInstance "$(hostname -i),${containerPort}" `
                    -Database $containerName `
                    -InputFile $scriptFileName `
                    -Username "sa" `
                    -Password "$(docker exec $containerName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" `
            }

            Write-Host "Script build successfuly! `n" -ForegroundColor Green
        }
        catch {
            Write-Error "$($_.exception.message)"
        }
    }
}