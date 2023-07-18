param (
    [parameter(Mandatory=$true)]
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

$moduleList = @("SqlServer")
$moduleList | ForEach-Object {
    $module = $_
    $modules = Get-InstalledModule | Where-Object { $_.Name -eq $module }
    if ($modules.Count -eq 0) {
        Write-Host "Installing module $($module)....." -ForegroundColor Yellow
        Install-Module -Name $module -RequiredVersion 22.1.1 -AllowClobber -Confirm:$False -Force
    }
}

$protosConfigPath = "$sourceDirectory\$protosConfigPath"

function ImportProtos {
    # TODO
}

function ExportProtos {
    Write-Output "Start exporting DATATINO_PROTO_1 tables"
    $protosConfig = [PSCustomObject]@{
        protos = New-Object System.Collections.Generic.List[PSCustomObject]
        configurations = New-Object System.Collections.Generic.List[PSCustomObject]
        views = New-Object System.Collections.Generic.List[PSCustomObject]
    }
    
    Write-Output "Exporting protos"
    $query = "select NAME, HEADER_NAMES, HEADER_VALUES, ACTIVE, DESCRIPTION from [dashboard-db].[DATATINO_PROTO_1].PROTOS;"
    $res = executeSql $query | ConvertFrom-Json
    foreach($item in $res) {
        $protosConfig.protos.Add(($item | Select-Object -Property $item.Table.Columns.Split(' ')))
    }
    Write-Output "Loaded $($protosConfig.protos.Count) rows from database"

    Write-Output "Exporting configurations"
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
    foreach($item in $res) {
        $protosConfig.configurations.Add(($item | Select-Object -Property $item.Table.Columns.Split(' ')))
    }
    Write-Output "Loaded $($protosConfig.configurations.Count) rows from database"

    Write-Output "Exporting views"
    $query = ("SELECT case when v.[CONSTRAINT_VALUE] like 'VR__' then 'VR' when v.[CONSTRAINT_VALUE] like 'GM____' then 'GM' else v.CONSTRAINT_VALUE end as constraintTag
            ,v.[NAME]
            ,v.[LAST_UPDATE_NAME]
            ,v.[CONSTRAINT_KEY_NAME]
            ,v.[GROUPED_KEY_NAME]
            ,v.[GROUPED_LAST_UPDATE_NAME]
        FROM [DATATINO_PROTO_1].[CONFIGURATIONS] c
        inner join [DATATINO_PROTO_1].[PROTOS] p on c.PROTO_ID = p.id and p.name not like 'IN_%'
        inner join [DATATINO_PROTO_1].[VIEWS] v on c.VIEW_ID = v.Id
        group by 
            v.[LAST_UPDATE_NAME]
            ,v.[CONSTRAINT_KEY_NAME]
            ,case when v.[CONSTRAINT_VALUE] like 'VR__' then 'VR'      when v.[CONSTRAINT_VALUE] like 'GM____' then 'GM'       else v.CONSTRAINT_VALUE      end
            ,v.[GROUPED_KEY_NAME]
            ,v.[GROUPED_LAST_UPDATE_NAME]
            ,v.[NAME]
        order by constraintTag, v.[NAME];")
    $res = executeSql $query | ConvertFrom-Json
    foreach($item in $res) {
        $protosConfig.views.Add(($item | Select-Object -Property $item.Table.Columns.Split(' ')))
    }
    Write-Output "Loaded $($protosConfig.views.Count) rows from database"

    Set-Content -Path "$protosConfigPath" -Value ($protosConfig | ConvertTo-Json -WarningAction SilentlyContinue)

    Write-Output "Finished exporting protos configurations"
}

function executeSql {
    param (
        [parameter(Mandatory=$true)]
        [string] $query
    )

    return Invoke-Sqlcmd `
        -ServerInstance "$hostName,$port" `
        -Database $databaseName `
        -Query $query `
        -TrustServerCertificate `
        -Username "sa" `
        -Password "$(docker exec $serverName /bin/bash -c 'echo $MSSQL_SA_PASSWORD')" | ConvertTo-Json -WarningAction SilentlyContinue
}

switch ($command) {
    "export" { ExportProtos }
    "import" { ImportProtos }
}
