param(
 [int]$port = 14331,
 [string]$hostName = $null,
 [string]$databaseName = "dashboard-db",
 [string]$serverName = "local-mssql",
 [string]$protosConfigPath = ".devops\protos.config.json",
 [String]$sourceDirectory = $env:PWD ?? $(Get-Location)
)

# --- --- ---
Write-Output "Loaded protos config file"
. "./.devops/scripts/helpers/helper-scripts.ps1"

if ($hostName.Length -eq 0) {
    $hostName = $(Set-LocalIPAddress)
}

$protosConfigPath = "$sourceDirectory\$protosConfigPath"
$protosConfig = Get-Content -Path $protosConfigPath | ConvertFrom-Json
$protosConfig.exclude ??= $true
# --- --- ---

Write-Output "Applying protos configuration changes"
foreach ($loadConfig in $protosConfig.protos) {
    $query = ""
    if ($loadConfig.name.Length -eq 2) { 
        if ($loadConfig.config.Length -gt 0) {
            $query += ("
            UPDATE c
            set c.ACTIVE = 0
            from [dashboard-db].[DATATINO_PROTO_1].[CONFIGURATIONS] c
            INNER JOIN [dashboard-db].[DATATINO_PROTO_1].PROTOS p
            ON p.ID = c.PROTO_ID
            WHERE p.NAME like '$($loadConfig.name)%' and c.NAME in ('$($loadConfig.config -join "','")');
            ")
        } else {
            $query += "UPDATE [DATATINO_PROTO_1].[PROTOS] SET ACTIVE = 0 WHERE NAME LIKE '$($loadConfig.name)%';";
        }
    } elseif ($loadConfig.name.Length -gt 2) {
        if ($loadConfig.config.Length -gt 0) {
            $query += ("
            UPDATE c
            set c.ACTIVE = 0
            from [dashboard-db].[DATATINO_PROTO_1].[CONFIGURATIONS] c
            INNER JOIN [dashboard-db].[DATATINO_PROTO_1].PROTOS p
            ON p.ID = c.PROTO_ID
            WHERE p.NAME = '$($loadConfig.name)' and c.NAME in ('$($loadConfig.config -join "','")');
            ")
        } else {
            $query += "UPDATE [DATATINO_PROTO_1].[PROTOS] SET ACTIVE = 0 WHERE NAME = '$($loadConfig.name)';";
        }
    }

    Invoke-RetryCommand -RetryCount 0 -ScriptBlock {
        Invoke-Sqlcmd `
                -ServerInstance "$hostName,$port" `
                -Database $databaseName `
                -Query $query `
                -TrustServerCertificate `
                -Username "sa" `
                -Password "$(docker exec $serverName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')"
    }
}
