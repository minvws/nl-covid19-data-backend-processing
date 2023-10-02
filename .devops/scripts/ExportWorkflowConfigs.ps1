Param(
    [String]$ExportLocation = "D:\Export\Acc",
    [String]$DatabaseName = "vwscdb-we-dev-mssql-database",
    [String]$DatabaseServer = "vwscdb-we-dev-mssql-server.database.windows.net,1433",
    [String]$DatabaseUser = "dbAdmin",
    [String]$DatabasePassword = ""
)

Function Retrieve-Sql($sqlConnection, $query ){
    $command = New-Object Data.SQLClient.SQLCommand($query, $sqlConnection)
    $command.Prepare()

    $reader = $command.ExecuteReader()

    $results = @()
    while ($reader.Read())
    {
        $row = [ordered]@{}
        for ($i = 0; $i -lt $reader.FieldCount; $i++)
        {
            $row[$reader.GetName($i)] = $reader.GetValue($i)
        }
        $results += new-object psobject -property $row            
    }

    $reader.Dispose()
    $command.Dispose()
    return $results
}

Function Export-ExternalDependencies($dependencies){
    $externalDependenciesLocation = "$ExportLocation\ExternalDependencies.config.json"
    Write-Host "Exporting external dependencies to $externalDependenciesLocation ..."

    $dependencies | ConvertTo-JSON -Depth 10 | Out-File $externalDependenciesLocation -Force
}

Function Export-Workflow($workflow, $processes, $localDependencies){
    $p = @()
    $d = @()
    $workflowLocation = "$ExportLocation\Workflows\$($workflow.NAME).config.json"

    $workflowProcesses = $processes | ? { $_.WORKFLOW_ID -eq $workflow.Id }    
    $workflowDependencies = $localDependencies | ? { $_.WORKFLOW_ID -eq $workflow.Id}

    foreach($workflowProcess in $workflowProcesses){
        $workflowProcess.PSObject.Properties.Remove('WORKFLOW_ID')

        $p += $workflowProcess 
    }

    foreach($workflowDependency in $workflowDependencies){
        $workflowDependency.PSObject.Properties.Remove('WORKFLOW_ID')

        $d += $workflowDependency 
    }

    $workflow.PSObject.Properties.Remove('ID')

    $workflow | Add-Member -MemberType NoteProperty -Name "PROCESSES" -Value $p
    $workflow | Add-Member -MemberType NoteProperty -Name "DEPENDENCIES" -Value $d

    Write-Host "Exporting workflow to $workflowLocation ..."
    $workflow | ConvertTo-JSON -Depth 10 | Out-File $workflowLocation -Force
}

Function Retrieve-Workflows($connection){
    $workflows = Retrieve-Sql $connection "
        select 
            wf.[ID]
            ,wf.[DATAFLOW_ID]
            ,wf.[SCHEDULE]
            ,wf.[ACTIVE]
            ,df.[NAME]
            ,df.[DESCRIPTION]
        from [DATATINO_ORCHESTRATOR_1].[WORKFLOWS] wf
        left join [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] df on wf.DATAFLOW_ID = df.ID
    "

    return $workflows
}

Function Retrieve-Processes($connection){
    $processes = Retrieve-Sql $connection  "
        select 
            p.[WORKFLOW_ID]
            ,p.[DATAFLOW_ID]
            ,p.[SCHEDULE]
            ,p.[ACTIVE]
            ,df.[NAME]
            ,df.[DESCRIPTION]
            ,s.[SOURCE_CONTENT]
            ,s.[SOURCE_COLUMNS]
            ,s.[TARGET_COLUMNS] as SOURCE_TARGET_COLUMNS
            ,s.[TARGET_NAME] as SOURCE_TARGET_NAME
            ,s.[NAME] as SOURCE_NAME
            ,s.[DESCRIPTION] as SOURCE_DESCRIPTION
            ,st.[NAME] as SOURCE_TYPE
            ,lt.[NAME] as SOURCE_LOCATION_TYPE
            ,dt.[NAME] as SOURCE_DELIMITER_TYPE
            ,sp.[NAME] as SOURCE_SECURITY_PROFILE
        from [DATATINO_ORCHESTRATOR_1].[PROCESSES] p
        left join [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] df on p.DATAFLOW_ID = df.ID
        left join [DATATINO_ORCHESTRATOR_1].[SOURCES] s on p.SOURCE_ID = s.ID
        left join [DATATINO_ORCHESTRATOR_1].[SOURCE_TYPES] st on s.SOURCE_TYPE_ID = st.ID
        left join [DATATINO_ORCHESTRATOR_1].[LOCATION_TYPES] lt on s.LOCATION_TYPE_ID = lt.ID
        left join [DATATINO_ORCHESTRATOR_1].[DELIMITER_TYPES] dt on s.DELIMITER_TYPE_ID = dt.ID
        left join [DATATINO_ORCHESTRATOR_1].[SECURITY_PROFILES] sp on s.SP_ID = sp.ID
"
    return $processes

}

Function Retrieve-LocalDependencies($connection){
    $localDependencies = Retrieve-Sql $connection "
        select 
            d.[WORKFLOW_ID]
            ,d.[NAME]
            ,d.[DESCRIPTION]  
            ,df1.[NAME] as DEPENDANT
            ,df2.[NAME] as DEPENDENT_ON
            ,d.[ACTIVE]
        from [DATATINO_ORCHESTRATOR_1].[DEPENDENCIES] d
        left join [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] df1 on d.DATAFLOW_ID = df1.ID
        left join [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] df2 on d.DEPENDENCY_ID = df2.ID
        left join [DATATINO_ORCHESTRATOR_1].[PROCESSES] df2_p on df2.ID = df2_p.DATAFLOW_ID
        left join [DATATINO_ORCHESTRATOR_1].[WORKFLOWS] w on d.WORKFLOW_ID = w.ID
        where df2_p.ID is not NULL
"
    return $localDependencies
}

Function Retrieve-ExternalDependencies($connection){
    $externalDependencies = Retrieve-Sql $connection "
        select 
            d.[NAME]
            ,d.[DESCRIPTION]  
            ,df1.[NAME] as DEPENDANT
            ,df2.[NAME] as DEPENDENT_ON_WORKFLOW
            ,d.[ACTIVE]
        from [DATATINO_ORCHESTRATOR_1].[DEPENDENCIES] d
        left join [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] df1 on d.DATAFLOW_ID = df1.ID
        left join [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] df2 on d.DEPENDENCY_ID = df2.ID
        left join [DATATINO_ORCHESTRATOR_1].[PROCESSES] df2_p on df2.ID = df2_p.DATAFLOW_ID
        left join [DATATINO_ORCHESTRATOR_1].[WORKFLOWS] w on d.WORKFLOW_ID = w.ID
        where df2_p.ID is NULL
" 
    return $externalDependencies

}

try {

    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = "server=$DatabaseServer;database=$DatabaseName;User=$DatabaseUser;Password=$DatabasePassword"
    $connection.Open()
    
    $workflows = Retrieve-Workflows $connection
    $processes = Retrieve-Processes $connection
    $localDependencies = Retrieve-LocalDependencies $connection
    $externalDependencies = Retrieve-ExternalDependencies $connection

    foreach($workflow in $workflows){
        Export-Workflow $workflow $processes $localDependencies
    }

    Export-ExternalDependencies $externalDependencies


} catch {
    Write-Host "Error: $_"
} finally {
    $connection.Close()
    $connection.Dispose()
}