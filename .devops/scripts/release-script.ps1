Param (
    [String]$Server = "$(hostname -i),14331",
    [String]$Database = "local-mssql",
    [String]$Password = $(docker exec $Database /bin/bash -c 'echo $MSSQL_SA_PASSWORD'),
    [String]$Username = "sa",
    [String]$SourceDirectory = $env:PWD
)

### LOAD EXTERNAL SCRIPT(S).....
. "./.devops/scripts/helpers/helper-scripts.ps1"

### MIGRATING/DEPLOYING MSSQL ARTIFACT(S)....
Write-Host "Start migration:" -ForegroundColor Green

try {
    $hashTable = @{}
    $scripts = $((Get-ChildItem -Path $SourceDirectory -Filter "*.sql") -Split ' ') | 
    ForEach-Object {
        $script = Split-Path -Path $_ -Leaf
        Write-Host "path is: [$script]"
        $hashTable.Add([int]([regex]::Match($script, '\d+').Value), $_)
    };

    $scripts = $($hashTable.GetEnumerator() | Sort-Object -Property name)

    foreach ($script in $scripts ) {
        
        Write-Host "$($script.Value)" -ForegroundColor Blue

        Invoke-RetryCommand -ScriptBlock { 
            Invoke-Sqlcmd `
                -ServerInstance $Server `
                -Database $Database `
                -InputFile $script.Value `
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