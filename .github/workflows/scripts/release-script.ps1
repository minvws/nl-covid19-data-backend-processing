Param (
    [String]$Server = "$(hostname -i),14331",
    [String]$Database = "a1049e34-6129-11ec-90d6-0242ac120003",
    [SecureString]$Password = $(docker exec $Database /bin/bash -c 'echo $MSSQL_SA_PASSWORD' | ConvertTo-SecureString -AsPlainText),
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
                -Password $(New-Object PSCredential $Username, $Password).GetNetworkCredential().Password `
                -Verbose 
        } -Verbose
        
    }

    Write-Host "Finished migrating!" -ForegroundColor Green
}
catch [Exception] {
    Write-Error "$($_)"
    throw
}

