CREATE   PROCEDURE DATATINO_ORCHESTRATOR.UPSERT_DEPENDENCY (
    @id BIGINT NULL,
    @process_name VARCHAR(MAX) NULL,
    @dependency_name VARCHAR(MAX) NULL,
    @workflow_name VARCHAR(MAX) NULL,
    @active INT = 1
) AS
    DECLARE @process_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR.PROCESSES WHERE [PROCESS_NAME] = @process_name)
    DECLARE @dependency_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR.PROCESSES WHERE [PROCESS_NAME] = @dependency_name)
    DECLARE @workflow_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE [WORKFLOW_NAME] = @workflow_name)
    IF @id IS NULL
        INSERT DATATINO_ORCHESTRATOR.DEPENDENCIES ( [PROCESS_ID], [DEPENDENCY], [WORKFLOW_ID], [ACTIVE] ) VALUES (
            @process_id,
            @dependency_id,
            @workflow_id,
            @active);
    ELSE
        IF @process_name IS NULL
            SET @process_id = (SELECT [PROCESS_ID] FROM DATATINO_ORCHESTRATOR.DEPENDENCIES WHERE ID = @id)
        IF @dependency_name IS NULL
            SET @dependency_id = (SELECT [DEPENDENCY] FROM DATATINO_ORCHESTRATOR.DEPENDENCIES WHERE ID = @id)
        IF @workflow_name IS NULL
            SET @workflow_id = (SELECT [WORKFLOW_ID] FROM DATATINO_ORCHESTRATOR.DEPENDENCIES WHERE ID = @id)
        IF @active IS NULL
            SET @active = (SELECT [ACTIVE] FROM DATATINO_ORCHESTRATOR.DEPENDENCIES WHERE ID = @id)
        UPDATE DATATINO_ORCHESTRATOR.DEPENDENCIES SET 
            [PROCESS_ID] = @process_id,
            [DEPENDENCY] = @dependency_id,
            [WORKFLOW_ID] = @workflow_id,
            [ACTIVE] = @active
        WHERE ID = @id