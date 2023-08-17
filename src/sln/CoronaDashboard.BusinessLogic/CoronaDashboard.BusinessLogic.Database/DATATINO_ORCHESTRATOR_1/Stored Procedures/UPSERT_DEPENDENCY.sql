CREATE   PROCEDURE [DATATINO_ORCHESTRATOR_1].[UPSERT_DEPENDENCY] (
    @id BIGINT NULL,
    @dataflow_name VARCHAR(MAX) NULL,
    @dataflowtype_id INT NULL,
    @dependency_name VARCHAR(MAX) NULL,
    @dependencytype_id INT NULL,
    @workflow_name VARCHAR(MAX) NULL,
    @name VARCHAR(MAX) NULL,
    @description  VARCHAR(MAX) NULL,
    @active INT = 1
) AS
    DECLARE @dataflow_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE [NAME] = @dataflow_name)
    DECLARE @dependency_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE [NAME] = @dependency_name)
    DECLARE @workflow_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR_1.WORKFLOWS WHERE DATAFLOW_ID = (SELECT [ID] FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE [NAME] = @workflow_name))
    IF @id IS NULL
        INSERT DATATINO_ORCHESTRATOR_1.DEPENDENCIES ( [DATAFLOW_ID], [DATAFLOW_TYPE_ID], [DEPENDENCY_ID], [DATAFLOW_TYPE_ID_DEPENDENCY], [WORKFLOW_ID], [ACTIVE], [NAME], [DESCRIPTION] ) VALUES (
            @dataflow_id,
            @dataflowtype_id,
            @dependency_id,
            @dependencytype_id,
            @workflow_id,
            @active,
            @name,
            @description);
    ELSE
        IF @dataflow_name IS NULL
            SET @dataflow_id = (SELECT [DATAFLOW_ID] FROM DATATINO_ORCHESTRATOR_1.DEPENDENCIES WHERE ID = @id)
        IF @dataflowtype_id IS NULL
            SET @dataflowtype_id = (SELECT [DATAFLOW_TYPE_ID] FROM DATATINO_ORCHESTRATOR_1.DEPENDENCIES WHERE ID = @id)
        IF @dependency_name IS NULL
            SET @dependency_id = (SELECT [DEPENDENCY_ID] FROM DATATINO_ORCHESTRATOR_1.DEPENDENCIES WHERE ID = @id)
        IF @dependencytype_id IS NULL
            SET @dependencytype_id = (SELECT [DATAFLOW_TYPE_ID_DEPENDENCY] FROM DATATINO_ORCHESTRATOR_1.DEPENDENCIES WHERE ID = @id)
        IF @workflow_name IS NULL
            SET @workflow_id = (SELECT [WORKFLOW_ID] FROM DATATINO_ORCHESTRATOR_1.DEPENDENCIES WHERE ID = @id)
        IF @active IS NULL
            SET @active = (SELECT [ACTIVE] FROM DATATINO_ORCHESTRATOR_1.DEPENDENCIES WHERE ID = @id)
        IF @name IS NULL
            SET @name = (SELECT [NAME] FROM DATATINO_ORCHESTRATOR_1.DEPENDENCIES WHERE ID = @id)
        IF @description IS NULL
            SET @description = (SELECT [DESCRIPTION] FROM DATATINO_ORCHESTRATOR_1.DEPENDENCIES WHERE ID = @id)
        UPDATE DATATINO_ORCHESTRATOR_1.DEPENDENCIES SET 
            [DATAFLOW_ID] = @dataflow_id,
            [DATAFLOW_TYPE_ID] = @dataflowtype_id,
            [DEPENDENCY_ID] = @dependency_id,
            [DATAFLOW_TYPE_ID_DEPENDENCY] = @dependencytype_id,
            [WORKFLOW_ID] = @workflow_id,
            [NAME] = @name,
            [DESCRIPTION]= @description,
            [ACTIVE] = @active
        WHERE ID = @id