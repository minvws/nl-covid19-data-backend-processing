param (
    [parameter(Mandatory = $true)]
    [string]$command,
    [int]$port,
    [string]$serverName = "(localdb)\MSSQLLocalDB",
    [string]$databaseName = "CoronaDashboard.BusinessLogic.Database",
    [string]$protosConfigPath = ".devops\protos.config.json",
    [String]$sourceDirectory = $env:PWD ?? $(Get-Location),
    [String]$username,
    [switch]$pass
)

# Load helper script
. "./.devops/scripts/helpers/helper-scripts.ps1"

### Set variables
# Path to protos.config.json file
$protosConfigPath = Join-Path -Path $sourceDirectory -ChildPath $protosConfigPath

# Additional parameters which are be added to the invoke-sql command.
[hashtable]$additionalParams = @{ }

# Set the password as a securestring variable. 
if ($pass) {
    $password = Read-Host 'Enter password: ' -AsSecureString
    $additionalParams["password"] = ConvertFrom-SecureString $password -AsPlainText
}

# Add username to additional params if it exists.
if($username) {
    $additionalParams["username"] = $username
}

### Function definitions
# This will import the protos.config.json file into the database
# In order to execute function: "<filename>.ps1 import"
function ImportProtos {
    Write-Host "Start importing DATATINO_PROTO_1 tables"
    $protosConfig = Get-Content -Path $protosConfigPath | ConvertFrom-Json -WarningAction SilentlyContinue
    $GMs = $protosConfig.protos | Where-Object NAME -Like "GM[0-9]*" # Selects all muncipalities from the protos list
    $VRs = $protosConfig.protos | Where-Object NAME -Like "VR[0-9]*" # Selects all safety regions from the protos list

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
    executeSql $query.Substring(0, $query.Length - 1)

    Write-Host "Importing VIEWS table" 
    [string]$query = $null
    foreach ($view in $protosConfig.views) {
        $prefix = ("INSERT INTO [DATATINO_PROTO_1].[VIEWS] 
            (CONSTRAINT_VALUE, NAME, LAST_UPDATE_NAME, 
            CONSTRAINT_KEY_NAME, GROUPED_KEY_NAME, 
            GROUPED_LAST_UPDATE_NAME, DESCRIPTION) VALUES ")
        [string]$res = $null
        if ($view.constraintValue -eq "GM") {
            $res = ($GMs | ForEach-Object { "('{0}','{1}','{2}','{3}','{4}','{5}','{6}')" -f `
                        $_.NAME, $view.NAME, $view.LAST_UPDATE_NAME, $view.CONSTRAINT_KEY_NAME, $view.GROUPED_KEY_NAME, $view.GROUPED_LAST_UPDATE_NAME, $view.DESCRIPTION `
                        -replace '''''', 'NULL'
                }) -join ','
        }
        elseif ($view.constraintValue -eq "VR") {
            $res = ($VRs | ForEach-Object { "('{0}','{1}','{2}','{3}','{4}','{5}','{6}')" -f `
                        $_.NAME, $view.NAME, $view.LAST_UPDATE_NAME, $view.CONSTRAINT_KEY_NAME, $view.GROUPED_KEY_NAME, $view.GROUPED_LAST_UPDATE_NAME, $view.DESCRIPTION `
                        -replace '''''', 'NULL'
                }) -join ','
        }
        elseif ($null -eq $view.constraintValue) {
            $res = "(NULL,'{0}','{1}','{2}','{3}','{4}','{5}')" `
                -f $view.NAME, $view.LAST_UPDATE_NAME, $view.CONSTRAINT_KEY_NAME, $view.GROUPED_KEY_NAME, $view.GROUPED_LAST_UPDATE_NAME, $view.DESCRIPTION `
                -replace '''''', 'NULL'
        }
        else {
            $res = "('{0}','{1}','{2}','{3}','{4}','{5}','{6}')" `
                -f $view.constraintValue, $view.NAME, $view.LAST_UPDATE_NAME, $view.CONSTRAINT_KEY_NAME, $view.GROUPED_KEY_NAME, $view.GROUPED_LAST_UPDATE_NAME, $view.DESCRIPTION `
                -replace '''''', 'NULL'
        }
        $query = -join ($query, $prefix, $res, ';')
    }
    executeSql $query

    Write-Host "Importing CONFIGURATIONS table" 
    [string]$query = $null
    foreach ($config in $protosConfig.configurations) {
        $prefix = ("INSERT INTO [DATATINO_PROTO_1].[CONFIGURATIONS] (
            PROTO_ID, 
            VIEW_ID, 
            CONSTRAINED, 
            GROUPED,
            COLUMNS, 
            MAPPING, 
            LAYOUT_TYPE_ID, 
            MOCK_ID, 
            ACTIVE, 
            NAME, 
            DESCRIPTION
        ) VALUES ")
        [string]$res = $null
        if ($config.protoTag -eq "GM") {
            $res = ($GMs | ForEach-Object { "({0},{1},{2},{3},'{4}','{5}',{6},{7},{8},'{9}','{10}')" -f `
                        "(SELECT ID FROM [DATATINO_PROTO_1].[PROTOS] WHERE NAME = '$($_.NAME)')", `
                        "(SELECT ID FROM [DATATINO_PROTO_1].[VIEWS] WHERE NAME = '$($config.ViewName)' AND CONSTRAINT_VALUE = '$($_.NAME)' AND GROUPED_KEY_NAME = '$($config.GROUPED_KEY_NAME)')", `
                        $config.CONSTRAINED, $config.GROUPED, $config.COLUMNS, $config.MAPPING, $config.LAYOUT_TYPE_ID, $config.MOCK_ID, $config.ACTIVE, $config.NAME, $config.DESCRIPTION `
                        -replace '''''', 'NULL' -replace ',,', ',NULL,' -replace '= NULL', 'IS NULL'
                }) -join ','
        }
        elseif ($config.protoTag -eq "VR") {
            $res = ($VRs | ForEach-Object { "({0},{1},{2},{3},'{4}','{5}',{6},{7},{8},'{9}','{10}')" -f `
                        "(SELECT ID FROM [DATATINO_PROTO_1].[PROTOS] WHERE NAME = '$($_.NAME)')", `
                        "(SELECT ID FROM [DATATINO_PROTO_1].[VIEWS] WHERE NAME = '$($config.ViewName)' AND CONSTRAINT_VALUE = '$($_.NAME)' AND GROUPED_KEY_NAME = '$($config.GROUPED_KEY_NAME)')", `
                        $config.CONSTRAINED, $config.GROUPED, $config.COLUMNS, $config.MAPPING, $config.LAYOUT_TYPE_ID, $config.MOCK_ID, $config.ACTIVE, $config.NAME, $config.DESCRIPTION `
                        -replace '''''', 'NULL' -replace ',,', ',NULL,' -replace '= NULL', 'IS NULL'
                }) -join ','
        }
        else {
            $res = "({0},{1},{2},{3},'{4}','{5}',{6},{7},{8},'{9}','{10}')" -f `
                "(SELECT ID FROM [DATATINO_PROTO_1].[PROTOS] WHERE NAME = '$($config.protoTag)')", `
                "(SELECT ID FROM [DATATINO_PROTO_1].[VIEWS] WHERE NAME = '$($config.ViewName)' AND CONSTRAINT_VALUE = '$($config.constraintValue)' AND GROUPED_KEY_NAME = '$($CONFIG.GROUPED_KEY_NAME)')", `
                $config.CONSTRAINED, $config.GROUPED, $config.COLUMNS, $config.MAPPING, $config.LAYOUT_TYPE_ID, $config.MOCK_ID, $config.ACTIVE, $config.NAME, $config.DESCRIPTION `
                -replace '''''', 'NULL' -replace ',,', ',NULL,' -replace '= NULL', 'IS NULL'
        }
        $query = -join ($query, $prefix, $res, '; ')
    }
    executeSql $query
}

# This will generate and export a protos.config.json file from the database
# In order to execute function: "<filename>.ps1 export"
function ExportProtos {
    Write-Host "Start exporting DATATINO_PROTO_1 tables"
    $protosConfig = [PSCustomObject]@{
        protos         = New-Object System.Collections.Generic.List[PSCustomObject]
        configurations = New-Object System.Collections.Generic.List[PSCustomObject]
        views          = New-Object System.Collections.Generic.List[PSCustomObject]
    }
    # Start exporting protos
    Write-Host "Exporting protos"
    $query = "select NAME, HEADER_NAMES, HEADER_VALUES, ACTIVE, DESCRIPTION from [dashboard-db].[DATATINO_PROTO_1].PROTOS;"
    $res = executeSql $query | ConvertFrom-Json
    foreach ($item in $res) {
        $protosConfig.protos.Add(($item | Select-Object -Property $item.Table.Columns.Split(' ')))
    }
    Write-Host "Loaded $($protosConfig.protos.Count) rows from database"

    # Start exporting views
    Write-Host "Exporting views"
    $query = ("SELECT case when [CONSTRAINT_VALUE] like 'VR__' then 'VR' when [CONSTRAINT_VALUE] like 'GM____' then 'GM' else [CONSTRAINT_VALUE] end as constraintValue
            ,[NAME]
            ,[LAST_UPDATE_NAME]
            ,[CONSTRAINT_KEY_NAME]
            ,[GROUPED_KEY_NAME]
            ,[GROUPED_LAST_UPDATE_NAME]
            ,MIN([DESCRIPTION]) as [DESCRIPTION]
        FROM [DATATINO_PROTO_1].[VIEWS]
        group by [LAST_UPDATE_NAME]
            ,[CONSTRAINT_KEY_NAME]
            ,case when [CONSTRAINT_VALUE] like 'VR__' then 'VR' when [CONSTRAINT_VALUE] like 'GM____' then 'GM' else [CONSTRAINT_VALUE] end
            ,[GROUPED_KEY_NAME]
            ,[GROUPED_LAST_UPDATE_NAME]
            ,[NAME]
        order by constraintValue, [NAME];")
    $res = executeSql $query | ConvertFrom-Json
    foreach ($item in $res) {
        $protosConfig.views.Add(($item | Select-Object -Property $item.Table.Columns.Split(' ')))
    }
    Write-Host "Loaded $($protosConfig.views.Count) rows from database"
    
    # Start exporting configurations
    Write-Host "Exporting configurations"
    $query = ("SELECT case when p.Name like 'VR__' then 'VR'  when p.Name like 'GM____' then 'GM'  else p.Name end   as protoTag
            ,case when v.[CONSTRAINT_VALUE] like 'VR__' then 'VR' when v.[CONSTRAINT_VALUE] like 'GM____' then 'GM' else v.[CONSTRAINT_VALUE] end as constraintValue
            ,v.Name as viewName
            ,v.[GROUPED_KEY_NAME] 
            ,c.[CONSTRAINED]
            ,c.[GROUPED]
            ,c.[COLUMNS]
            ,c.[MAPPING]
            ,c.[LAYOUT_TYPE_ID]
            ,c.[MOCK_ID]
            ,c.[ACTIVE]
            ,c.[NAME]
            ,MIN(c.[DESCRIPTION]) as [DESCRIPTION]
        FROM [DATATINO_PROTO_1].[CONFIGURATIONS] c
        inner join [DATATINO_PROTO_1].[PROTOS] p on c.PROTO_ID = p.id and p.name not like 'IN_%'
        inner join [DATATINO_PROTO_1].[VIEWS] v on c.VIEW_ID = v.Id
        group by 
            c.[CONSTRAINED]
            ,v.[GROUPED_KEY_NAME] 
            ,c.[GROUPED]
            ,c.[COLUMNS]
            ,c.[MAPPING]
            ,c.[LAYOUT_TYPE_ID]
            ,c.[MOCK_ID]
            ,c.[ACTIVE]
            ,c.[NAME]
            ,case when v.[CONSTRAINT_VALUE] like 'VR__' then 'VR' when v.[CONSTRAINT_VALUE] like 'GM____' then 'GM' else v.CONSTRAINT_VALUE end
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

# Helper function used to execute queries
function executeSql {
    param (
        [Parameter(
            Position = 0, 
            Mandatory = $true, 
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string] $query
    )

    return Invoke-Sqlcmd @additionalParams `
        -ServerInstance ($port ? "$serverName,$port" : $serverName)`
        -Database $databaseName `
        -Query $query `
        -ErrorAction Stop | ConvertTo-Json -WarningAction SilentlyContinue
}

### Determines which function to execute
switch ($command) {
    "export" { Measure-Command { ExportProtos } }
    "import" { Measure-Command { ImportProtos } }
}