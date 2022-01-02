Param (
    [String]$Server = "$(hostname -i),14331",
    [String]$Database = "local-mssql",
    [String]$Password = $(docker exec $Database /bin/bash -c 'echo $MSSQL_SA_PASSWORD'),
    [String]$Username = "sa",
    [String]$SourceDirectory = $env:PWD
)

### LOAD EXTERNAL SCRIPT(S).....
. "$($SourceDirectory)/../scripts/helpers/helper-scripts.ps1"

### MIGRATING/DEPLOYING MSSQL ARTIFACT(S)....
Write-Host "Start migration:" -ForegroundColor Green

try {

    $scripts = $((Get-ChildItem -Path $SourceDirectory -Filter "*.sql") -Split ' ') | Sort-Object
    foreach ($script in $scripts | Sort-Object -Property Fullname) {

        Write-Host "$($script)" -ForegroundColor Blue

        Invoke-RetryCommand -ScriptBlock { 
            Invoke-Sqlcmd `
                -ServerInstance $Server `
                -Database $Database `
                -InputFile $script `
                -Username $Username `
                -Password $Password `
                -Verbose 
        } -Verbose
        
    }

    Write-Host "Finished migrating!" -ForegroundColor Green
}
catch [Exception] {
    Write-Error "$($_)"
    throw
}

