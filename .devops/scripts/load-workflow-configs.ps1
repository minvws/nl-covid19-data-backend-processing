Param(
    [String]$ExportLocation = ".devops\configs\workflows",
    [String]$DatabaseName = "vwscdb-we-acc-mssql-database",
    [String]$DatabaseServer = "vwscdb-we-acc-mssql-server.database.windows.net,1433",
    [String]$DatabaseUser = "dbAdmin",
    [String]$DatabasePassword = ""
)


Function Insert-GlobalDependency($connection, $dependencyConfig)
{
    $query = "

	    declare @dependantDataflowId int
	    declare @dependentOnDataflowId int
	    declare @workflowId int
	    declare @dataflowTypeIdProcess int
	    declare @dataflowTypeIdWorkflow int

        set @dataflowTypeIdProcess = (select [ID] from [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] where [NAME] = 'Process')
        set @dataflowTypeIdWorkflow = (select [ID] from [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] where [NAME] = 'Workflow')

        set @dependantDataflowId = (select [ID] from [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] where [NAME] = @dependantName)
        set @dependentOnDataflowId = (select [ID] from [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] where [NAME] = @dependentOnName)
        set @workflowId = (select p.[WORKFLOW_ID] from [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] df_p left join [DATATINO_ORCHESTRATOR_1].[PROCESSES] p on df_p.[ID] = p.[DATAFLOW_ID] where df_p.[NAME] = @dependantName)

        insert into  [DATATINO_ORCHESTRATOR_1].[DEPENDENCIES] (
              [DATAFLOW_ID]
              ,[DATAFLOW_TYPE_ID]
              ,[DEPENDENCY_ID]
              ,[DATAFLOW_TYPE_ID_DEPENDENCY]
              ,[WORKFLOW_ID]
              ,[ACTIVE]
              ,[NAME]
              ,[DESCRIPTION]) 
        values (@dependantDataflowId, @dataflowTypeIdProcess, @dependentOnDataflowId, @dataflowTypeIdWorkflow, @workflowId, @active, @name, @description)

    "

    $command = New-Object Data.SQLClient.SQLCommand($null, $connection)
    $command.CommandText = $query

    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@workflowDataflowId', [Data.SQLDBType]::Int, 0))).Value = $workflowConfig.DATAFLOW_ID
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@name', [Data.SQLDBType]::NVarChar, 200))).Value = $dependencyConfig.NAME
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@description', [Data.SQLDBType]::NVarChar, 4000))).Value = $dependencyConfig.DESCRIPTION
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@active', [Data.SQLDBType]::Int, 0))).Value = $dependencyConfig.ACTIVE
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dependantName', [Data.SQLDBType]::NVarChar, 200))).Value = $dependencyConfig.DEPENDANT
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dependentOnName', [Data.SQLDBType]::NVarChar, 200))).Value = $dependencyConfig.DEPENDENT_ON_WORKFLOW

    $command.Prepare()
    $command.ExecuteNonQuery() | Out-Null
    $command.Dispose()

}

Function Upsert-Dataflow($connection, $dataflowId, $dataflowName, $dataflowDescription, $dataflowType)
{

    $query = "
    
        declare @dataflowTypeId int

        set @dataflowTypeId = (select Id from [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] where name = @dataflowType)

        set identity_insert [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] on

        IF EXISTS(SELECT * FROM [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] WHERE [ID] = @dataflowId)
        BEGIN
            --update existing row
            UPDATE [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] 
	        SET 
		        [NAME] = @dataflowName,
		        [DESCRIPTION] = @dataflowDescription
            WHERE [ID] = @dataflowId
        END
        ELSE
        BEGIN
            --insert new row
            INSERT INTO [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] ([ID], [NAME], [DESCRIPTION], [DATAFLOW_TYPE_ID])
            VALUES (@dataflowId, @dataflowName, @dataflowDescription, @dataflowTypeId)
        END

        set identity_insert [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] off
    
    "

    $command = New-Object Data.SQLClient.SQLCommand($null, $connection)
    $command.CommandText = $query
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dataflowId', [Data.SQLDBType]::Int, 0))).Value = $dataflowId
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dataflowName', [Data.SQLDBType]::NVarChar, 200))).Value = $dataflowName
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dataflowType', [Data.SQLDBType]::NVarChar, 200))).Value = $dataflowType
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dataflowDescription', [Data.SQLDBType]::NVarChar, 4000))).Value = $dataflowDescription


    $command.Prepare()
    $command.ExecuteNonQuery() | Out-Null
    $command.Dispose()
}

Function Upsert-DataflowWorkflow($connection, $workflowConfig)
{

    $query = "
    
        declare @dataflowTypeId int

        set @dataflowTypeId = (select Id from [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] where name = 'Workflow')

        set identity_insert [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] on

        IF EXISTS(SELECT * FROM [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] WHERE [ID] = @dataflowId)
        BEGIN
            --update existing row
            UPDATE [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] 
	        SET 
		        [NAME] = @dataflowName,
		        [DESCRIPTION] = @dataflowDescription
            WHERE [ID] = @dataflowId
        END
        ELSE
        BEGIN
            --insert new row
            INSERT INTO [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] ([ID], [NAME], [DESCRIPTION], [DATAFLOW_TYPE_ID])
            VALUES (@dataflowId, @dataflowName, @dataflowDescription, @dataflowTypeId)
        END

        set identity_insert [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] off
    
    "

    $command = New-Object Data.SQLClient.SQLCommand($null, $connection)
    $command.CommandText = $query
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dataflowId', [Data.SQLDBType]::Int, 0))).Value = $workflowConfig.DATAFLOW_ID
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dataflowName', [Data.SQLDBType]::NVarChar, 200))).Value = $workflowConfig.NAME
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dataflowDescription', [Data.SQLDBType]::NVarChar, 4000))).Value = $workflowConfig.DESCRIPTION


    $command.Prepare()
    $command.ExecuteNonQuery() | Out-Null
    $command.Dispose()
}


Function Insert-Workflow($connection, $workflowConfig)
{
    $query = "
    
        declare @dataflowTypeId int
        declare @lastRun datetime2
        declare @nextRun datetime2 = NULL

        set @dataflowTypeId = (select Id from [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] where name = 'Workflow')
        set @lastRun = (select max([START_RUN]) from [DATATINO_ORCHESTRATOR_1].[H_DATAFLOWS] where [DATAFLOW_ID] = @dataflowId)

        insert into  [DATATINO_ORCHESTRATOR_1].[WORKFLOWS] (
	        [DATAFLOW_ID]
	        ,[DATAFLOW_TYPE_ID]
	        ,[SCHEDULE]
	        ,[NEXT_RUN]
	        ,[LAST_RUN]
	        ,[ACTIVE]) 
        values (@dataflowId, @dataflowTypeId, @schedule, @nextRun, @lastRun, @active)
    
    "

    $command = New-Object Data.SQLClient.SQLCommand($null, $connection)
    $command.CommandText = $query
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dataflowId', [Data.SQLDBType]::Int, 0))).Value = $workflowConfig.DATAFLOW_ID
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@schedule', [Data.SQLDBType]::NVarChar, 100))).Value = $workflowConfig.SCHEDULE
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@active', [Data.SQLDBType]::Int, 0))).Value = $workflowConfig.ACTIVE


    $command.Prepare()
    $command.ExecuteNonQuery() | Out-Null
    $command.Dispose()

}

Function Insert-Dependency($connection, $workflowConfig, $dependencyConfig)
{
    $query = "

	    declare @dependantDataflowId int
	    declare @dependentOnDataflowId int
	    declare @workflowId int
	    declare @dataflowTypeId int

        set @dataflowTypeId = (select [ID] from [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] where [NAME] = 'Process')
        set @dependantDataflowId = (select [ID] from [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] where [NAME] = @dependantName)
        set @dependentOnDataflowId = (select [ID] from [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] where [NAME] = @dependentOnName)
        set @workflowId = (select [ID] from [DATATINO_ORCHESTRATOR_1].[WORKFLOWS] where [DATAFLOW_ID] = @workflowDataflowId)

        insert into  [DATATINO_ORCHESTRATOR_1].[DEPENDENCIES] (
              [DATAFLOW_ID]
              ,[DATAFLOW_TYPE_ID]
              ,[DEPENDENCY_ID]
              ,[DATAFLOW_TYPE_ID_DEPENDENCY]
              ,[WORKFLOW_ID]
              ,[ACTIVE]
              ,[NAME]
              ,[DESCRIPTION]) 
        values (@dependantDataflowId, @dataflowTypeId, @dependentOnDataflowId, @dataflowTypeId, @workflowId, @active, @name, @description)

    "

    $command = New-Object Data.SQLClient.SQLCommand($null, $connection)
    $command.CommandText = $query

    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@workflowDataflowId', [Data.SQLDBType]::Int, 0))).Value = $workflowConfig.DATAFLOW_ID
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@name', [Data.SQLDBType]::NVarChar, 200))).Value = $dependencyConfig.NAME
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@description', [Data.SQLDBType]::NVarChar, 4000))).Value = $dependencyConfig.DESCRIPTION
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@active', [Data.SQLDBType]::Int, 0))).Value = $dependencyConfig.ACTIVE
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dependantName', [Data.SQLDBType]::NVarChar, 200))).Value = $dependencyConfig.DEPENDANT
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@dependentOnName', [Data.SQLDBType]::NVarChar, 200))).Value = $dependencyConfig.DEPENDENT_ON

    $command.Prepare()
    $command.ExecuteNonQuery() | Out-Null
    $command.Dispose()

}

Function Insert-Process($connection, $workflowConfig, $processConfig)
{

    $query = "

    declare @sourceId int
    declare @sourceTypeId int = (select Id from [DATATINO_ORCHESTRATOR_1].[SOURCE_TYPES] where [NAME] = @sourceType)
    declare @locationTypeId int = (select Id from [DATATINO_ORCHESTRATOR_1].[LOCATION_TYPES] where [NAME] = @sourceLocationType)
    declare @delimiterTypeId int = (select Id from [DATATINO_ORCHESTRATOR_1].[DELIMITER_TYPES] where [NAME] = @sourceDelimiterType)
    declare @securityProfileId int = (select Id from [DATATINO_ORCHESTRATOR_1].[SECURITY_PROFILES] where [NAME] = @sourceSecurityProfile)

    insert into  [DATATINO_ORCHESTRATOR_1].[SOURCES] (
		    [SOURCE_CONTENT]
          ,[SOURCE_COLUMNS]
          ,[TARGET_COLUMNS]
          ,[TARGET_NAME]
          ,[SOURCE_TYPE_ID]
          ,[LOCATION_TYPE_ID]
          ,[DELIMITER_TYPE_ID]
          ,[SP_ID]
          ,[NAME]
          ,[DESCRIPTION]) 
    values (@sourceContent, @sourceColumns, @sourceTargetColumns, @sourceTargetName, @sourceTypeId, @locationTypeId, @delimiterTypeId, @securityProfileId, @sourceName, @sourceDescription)

    set @sourceId = (SELECT SCOPE_IDENTITY())

    declare @nextRun datetime2 = NULL
    declare @lastRun datetime2 = NULL

    declare @workflowId int
    declare @dataflowTypeId int

    set @dataflowTypeId = (select Id from [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] where name = 'Process')
    set @lastRun = (select max([START_RUN]) from [DATATINO_ORCHESTRATOR_1].[H_DATAFLOWS] where [DATAFLOW_ID] = @processDataflowId)
    set @workflowId = (select w.ID from [DATATINO_ORCHESTRATOR_1].[WORKFLOWS] w where w.DATAFLOW_ID = @workflowDataflowId)

    insert into  [DATATINO_ORCHESTRATOR_1].[PROCESSES] (
          [WORKFLOW_ID]
          ,[SOURCE_ID]
          ,[DATAFLOW_ID]
          ,[DATAFLOW_TYPE_ID]
          ,[SCHEDULE]
          ,[NEXT_RUN]
          ,[LAST_RUN]
          ,[ACTIVE]) 
    values (@workflowId, @sourceId, @processDataflowId, @dataflowTypeId, @schedule, @nextRun, @lastRun, @active)


    "
    $command = New-Object Data.SQLClient.SQLCommand($null, $connection)
    $command.CommandText = $query
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@sourceType', [Data.SQLDBType]::NVarChar, 200))).Value = $processConfig.SOURCE_TYPE
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@sourceLocationType', [Data.SQLDBType]::NVarChar, 200))).Value = $processConfig.SOURCE_LOCATION_TYPE
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@sourceDelimiterType', [Data.SQLDBType]::NVarChar, 200))).Value = $processConfig.SOURCE_DELIMITER_TYPE
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@sourceSecurityProfile', [Data.SQLDBType]::NVarChar, 200))).Value = $processConfig.SOURCE_SECURITY_PROFILE
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@sourceContent', [Data.SQLDBType]::NVarChar, 4000))).Value = $processConfig.SOURCE_CONTENT
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@sourceColumns', [Data.SQLDBType]::NVarChar, 4000))).Value = $(if ($processConfig.SOURCE_COLUMNS) { $processConfig.SOURCE_COLUMNS } else { [DBNull]::Value })
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@sourceTargetColumns', [Data.SQLDBType]::NVarChar, 4000))).Value = $(if ($processConfig.SOURCE_TARGET_COLUMNS) { $processConfig.SOURCE_TARGET_COLUMNS } else { [DBNull]::Value }) 
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@sourceTargetName', [Data.SQLDBType]::NVarChar, 200))).Value = $(if ($processConfig.SOURCE_TARGET_NAME) { $processConfig.SOURCE_TARGET_NAME } else { [DBNull]::Value }) 
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@sourceName', [Data.SQLDBType]::NVarChar, 4000))).Value = $(if ($processConfig.SOURCE_NAME) { $processConfig.SOURCE_NAME } else { [DBNull]::Value }) 
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@sourceDescription', [Data.SQLDBType]::NVarChar, 4000))).Value = $(if ($processConfig.SOURCE_DESCRIPTION) { $processConfig.SOURCE_DESCRIPTION } else { [DBNull]::Value }) 

    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@active', [Data.SQLDBType]::Int, 0))).Value = $processConfig.ACTIVE
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@processDataflowId', [Data.SQLDBType]::Int, 0))).Value = $processConfig.DATAFLOW_ID
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@workflowDataflowId', [Data.SQLDBType]::Int, 0))).Value = $workflowConfig.DATAFLOW_ID
    $command.Parameters.Add((New-Object Data.SqlClient.SqlParameter('@schedule', [Data.SQLDBType]::NVarChar, 100))).Value = $processConfig.SCHEDULE

    $command.Prepare()
    $command.ExecuteNonQuery() | Out-Null
    $command.Dispose()
}

Function Insert-Processes ($connection, $workflowConfig)
{
    foreach($workflowProcess in $workflowConfig.PROCESSES)
    {
        Upsert-Dataflow $connection $workflowProcess.DATAFLOW_ID $workflowProcess.NAME $workflowProcess.DESCRIPTION 'Process' 
        Insert-Process $connection $workflowConfig $workflowProcess
    }

    foreach($dependency in $workflowConfig.DEPENDENCIES)
    {
        Insert-Dependency $connection $workflowConfig $dependency
    }
}

Function Import-Workflow($connection, $workflowConfig)
{
    Write-Host "Importing workflow [$($workflowConfig.NAME)] with Dataflow Id [$($workflowConfig.DATAFLOW_ID)] ..."

    Upsert-Dataflow $connection $workflowConfig.DATAFLOW_ID $workflowConfig.NAME $workflowConfig.DESCRIPTION 'Workflow' 
    Insert-Workflow $connection $workflowConfig
    Insert-Processes $connection $workflowConfig

}

Function Import-GlobalDependencies($connection, $globalDependencies){
    foreach($dependency in $globalDependencies){
        Insert-GlobalDependency $connection $dependency
    }
}

Function Truncate-Tables($connection)
{
    $tableNames = @(
        '[DATATINO_ORCHESTRATOR_1].[DEPENDENCIES]',
        '[DATATINO_ORCHESTRATOR_1].[PROCESSES]',
        '[DATATINO_ORCHESTRATOR_1].[SOURCES]',
        '[DATATINO_ORCHESTRATOR_1].[WORKFLOWS]'
    )

    foreach($tableName in $tableNames){
        $query = "

            DELETE FROM $tableName
            DBCC CHECKIDENT ('$DatabaseName.$tableName', RESEED, 0)    
        
        "

        $command = New-Object Data.SQLClient.SQLCommand($null, $connection)
        $command.CommandText = $query
        $command.ExecuteNonQuery() | Out-Null
        $command.Dispose()
    }

}

try {

    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = "server=$DatabaseServer;database=$DatabaseName;User=$DatabaseUser;Password=$DatabasePassword"
    $connection.Open()
    
    Truncate-Tables $connection

    (Get-ChildItem "$ExportLocation\Workflows").FullName | % {
        $workflowConfigLocation = $_

        Write-Host "Reading file $workflowConfigLocation ..."

        $workflowConfig = Get-Content $workflowConfigLocation | ConvertFrom-Json
        Import-Workflow $connection $workflowConfig
    }

    $globalDependencies = Get-Content "$ExportLocation\ExternalDependencies.config.json" | ConvertFrom-Json
    Import-GlobalDependencies $connection $globalDependencies



} catch {
    Write-Host "Error: $_"
} finally {
    $connection.Close()
    $connection.Dispose()
}