param (
    [parameter(Mandatory = $true)]
    [string]$command,
    [int]$port = 14331,
    [string]$hostName = ([System.Net.DNS]::GetHostAddresses((hostname)) |
        Where-Object { $_.AddressFamily -eq "InterNetwork" } |  
        Select-Object IPAddressToString)[0].IPAddressToString,
    [string]$databaseName = "dashboard-db",
    [string]$serverName = "local-mssql",
    [string]$protosConfigPath = ".devops\protos.config.json",
    [String]$sourceDirectory = $env:PWD ?? $(Get-Location)
)

. "./.devops/scripts/helpers/helper-scripts.ps1"

$protosConfigPath = "$sourceDirectory\$protosConfigPath"

function ImportProtos {
    Write-Host "Start importing DATATINO_PROTO_1 tables"
    $protosConfig = Get-Content -Path $protosConfigPath | ConvertFrom-Json -WarningAction SilentlyContinue
    $GMs = $protosConfig.protos | Where-Object NAME -Like "GM[0-9]*"
    $VRs = $protosConfig.protos | Where-Object NAME -Like "VR[0-9]*"

    Write-Host "Truncating tables"
    ("DELETE FROM [DATATINO_PROTO_1].[CONFIGURATIONS];
    DELETE FROM [DATATINO_PROTO_1].[PROTOS]; 
    DELETE FROM [DATATINO_PROTO_1].[VIEWS];") | executeSql -ErrorAction Stop

    Write-Host "Reseed tables"
    ("DBCC CHECKIDENT ('[DATATINO_PROTO_1].[CONFIGURATIONS]', RESEED, 0);
    DBCC CHECKIDENT ('[DATATINO_PROTO_1].[PROTOS]', RESEED, 0); 
    DBCC CHECKIDENT ('[DATATINO_PROTO_1].[VIEWS]', RESEED, 0);") | executeSql -ErrorAction Stop

    Write-Host "Importing PROTOS table"
    $query = "insert into [DATATINO_PROTO_1].[PROTOS] (NAME, HEADER_NAMES, HEADER_VALUES, ACTIVE, DESCRIPTION) values "
    foreach ($proto in $protosConfig.protos) {
        $query += "('{0}','{1}','{2}',{3},'{4}')," -f $proto.NAME, $proto.HEADER_NAMES, $proto.HEADER_VALUES, $proto.ACTIVE, $proto.DESCRIPTION
    }
    executeSql $query.Substring(0, $query.Length-1)

    Write-Host "Importing VIEWS table" 
    [string]$query = $null
    foreach ($view in $protosConfig.views) {
        $prefix = ("INSERT INTO [DATATINO_PROTO_1].[VIEWS] 
            (CONSTRAINT_VALUE, NAME, LAST_UPDATE_NAME, 
            CONSTRAINT_KEY_NAME, GROUPED_KEY_NAME, 
            GROUPED_LAST_UPDATE_NAME, DESCRIPTION) VALUES ")
        [string]$res = $null
        if($view.constraintTag -eq "GM") {
            $res = ($GMs | ForEach-Object {"('{0}','{1}','{2}','{3}','{4}','{5}','{6}')" -f `
                    $_.NAME, $view.NAME, $view.LAST_UPDATE_NAME, $view.CONSTRAINT_KEY_NAME, $view.GROUPED_KEY_NAME, $view.GROUPED_LAST_UPDATE_NAME, $view.DESCRIPTION `
                    -replace '''''','NULL'
            }) -join ','
        } elseif ($view.constraintTag -eq "VR") {
            $res = ($VRs | ForEach-Object {"('{0}','{1}','{2}','{3}','{4}','{5}','{6}')" -f `
                    $_.NAME, $view.NAME, $view.LAST_UPDATE_NAME, $view.CONSTRAINT_KEY_NAME, $view.GROUPED_KEY_NAME, $view.GROUPED_LAST_UPDATE_NAME, $view.DESCRIPTION `
                    -replace '''''','NULL'
            }) -join ','
        } elseif ($null -eq $view.constraintTag) {
            $res = "(NULL,'{0}','{1}','{2}','{3}','{4}','{5}')" `
                -f $view.NAME, $view.LAST_UPDATE_NAME, $view.CONSTRAINT_KEY_NAME, $view.GROUPED_KEY_NAME, $view.GROUPED_LAST_UPDATE_NAME, $view.DESCRIPTION `
                -replace '''''','NULL'
        } else {
            $res = "('{0}','{1}','{2}','{3}','{4}','{5}','{6}')" `
                -f $view.constraintTag, $view.NAME, $view.LAST_UPDATE_NAME, $view.CONSTRAINT_KEY_NAME, $view.GROUPED_KEY_NAME, $view.GROUPED_LAST_UPDATE_NAME, $view.DESCRIPTION `
                -replace '''''','NULL'
        }
        $query = -join ($query, $prefix, $res, ';')
    }
    executeSql $query
}

function ExportProtos {
    Write-Host "Start exporting DATATINO_PROTO_1 tables"
    $protosConfig = [PSCustomObject]@{
        protos         = New-Object System.Collections.Generic.List[PSCustomObject]
        configurations = New-Object System.Collections.Generic.List[PSCustomObject]
        views          = New-Object System.Collections.Generic.List[PSCustomObject]
    }
    
    Write-Host "Exporting protos"
    $query = "select NAME, HEADER_NAMES, HEADER_VALUES, ACTIVE, DESCRIPTION from [dashboard-db].[DATATINO_PROTO_1].PROTOS;"
    $res = executeSql $query | ConvertFrom-Json
    foreach ($item in $res) {
        $protosConfig.protos.Add(($item | Select-Object -Property $item.Table.Columns.Split(' ')))
    }
    Write-Host "Loaded $($protosConfig.protos.Count) rows from database"

    Write-Host "Exporting views"
    $query = ("SELECT case when [CONSTRAINT_VALUE] like 'VR__' then 'VR' when [CONSTRAINT_VALUE] like 'GM____' then 'GM' else [CONSTRAINT_VALUE] end as constraintTag
            ,[NAME]
            ,[LAST_UPDATE_NAME]
            ,[CONSTRAINT_KEY_NAME]
            ,[GROUPED_KEY_NAME]
            ,[GROUPED_LAST_UPDATE_NAME]
            ,[DESCRIPTION]
        FROM [DATATINO_PROTO_1].[VIEWS]
        group by [LAST_UPDATE_NAME]
            ,[CONSTRAINT_KEY_NAME]
            ,case when [CONSTRAINT_VALUE] like 'VR__' then 'VR' when [CONSTRAINT_VALUE] like 'GM____' then 'GM' else [CONSTRAINT_VALUE] end
            ,[GROUPED_KEY_NAME]
            ,[GROUPED_LAST_UPDATE_NAME]
            ,[NAME]
            ,[DESCRIPTION]
        order by constraintTag, [NAME];")
    $res = executeSql $query | ConvertFrom-Json
    foreach ($item in $res) {
        $protosConfig.views.Add(($item | Select-Object -Property $item.Table.Columns.Split(' ')))
    }
    Write-Host "Loaded $($protosConfig.views.Count) rows from database"
    
    Write-Host "Exporting configurations"
    $query = ("SELECT case when p.Name like 'VR__' then 'VR'  when p.Name like 'GM____' then 'GM'  else p.Name end   as protoTag
            ,v.Name as ViewName
            ,c.[CONSTRAINED]
            ,c.[GROUPED]
            ,c.[COLUMNS]
            ,c.[MAPPING]
            ,c.[LAYOUT_TYPE_ID]
            ,c.[MOCK_ID]
            ,c.[ACTIVE]
            ,c.[NAME]
            ,c.[DESCRIPTION]
        FROM [DATATINO_PROTO_1].[CONFIGURATIONS] c
        inner join [DATATINO_PROTO_1].[PROTOS] p on c.PROTO_ID = p.id and p.name not like 'IN_%'
        inner join [DATATINO_PROTO_1].[VIEWS] v on c.VIEW_ID = v.Id
        group by 
            c.[CONSTRAINED]
            ,c.[GROUPED]
            ,c.[COLUMNS]
            ,c.[MAPPING]
            ,c.[LAYOUT_TYPE_ID]
            ,c.[MOCK_ID]
            ,c.[ACTIVE]
            ,c.[NAME]
            ,c.[DESCRIPTION]
            ,case when p.Name like 'VR__' then 'VR'  when p.Name like 'GM____' then 'GM'  else p.Name end 
            ,v.[NAME]
        order by protoTag, c.Name;")
    $res = executeSql $query | ConvertFrom-Json
    foreach ($item in $res) {
        $protosConfig.configurations.Add(($item | Select-Object -Property $item.Table.Columns.Split(' ')))
    }
    Write-Host "Loaded $($protosConfig.configurations.Count) rows from database"

    Set-Content -Path "$protosConfigPath" -Value ($protosConfig | ConvertTo-Json -WarningAction SilentlyContinue)

    Write-Host "Finished exporting protos configurations"
}

function executeSql {
    param (
        [Parameter(
            Position = 0, 
            Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string] $query
    )

    return Invoke-Sqlcmd `
        -ServerInstance "$hostName,$port" `
        -Database $databaseName `
        -Query $query `
        -Username "sa" `
        -Password "$(docker exec $serverName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" | ConvertTo-Json -WarningAction SilentlyContinue
}

switch ($command) {
    "export" { Measure-Command{ ExportProtos} }
    "import" { Measure-Command{ ImportProtos } }
}
