CREATE   PROCEDURE [DATATINO_ORCHESTRATOR].[UPSERT_PROCESS] (
    @id BIGINT NULL,
    @process_name VARCHAR(MAX) NULL, 
    @description VARCHAR(MAX) NULL, 
    @source_name VARCHAR(MAX) NULL, 
    @workflow_name VARCHAR(MAX) NULL, 
    @active INT = 1
) AS
    DECLARE @source_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR.SOURCES WHERE [SOURCE_NAME] = @source_name)
    DECLARE @workflow_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE [WORKFLOW_NAME] = @workflow_name)
    IF @id IS NULL
        INSERT INTO DATATINO_ORCHESTRATOR.PROCESSES([PROCESS_NAME], [DESCRIPTION], [SOURCE_ID], [WORKFLOW_ID], [ACTIVE]) 
        VALUES (@process_name, 
                @description, 
                @source_id,
                @workflow_id,
                @active)
    ELSE
        IF @process_name IS NULL
            SET @process_name = (SELECT [PROCESS_NAME] FROM DATATINO_ORCHESTRATOR.PROCESSES WHERE [ID] = @id)
        IF @description IS NULL
            SET @description = (SELECT [DESCRIPTION] FROM DATATINO_ORCHESTRATOR.PROCESSES WHERE [ID] = @id)
        IF @workflow_id IS NULL
            SET @workflow_id = (SELECT [WORKFLOW_ID] FROM DATATINO_ORCHESTRATOR.PROCESSES WHERE [ID] = @id)
        IF @source_id IS NULL
            SET @source_id = (SELECT [SOURCE_ID] FROM DATATINO_ORCHESTRATOR.PROCESSES WHERE [ID] = @id)
        IF @active IS NULL
            SET @active = (SELECT [ACTIVE] FROM DATATINO_ORCHESTRATOR.PROCESSES WHERE [ID] = @id)
        UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET 
            [PROCESS_NAME] = @process_name,
            [DESCRIPTION] = @description,
            [WORKFLOW_ID] = @workflow_id,
            [SOURCE_ID] = @source_id,
            [ACTIVE] = @active
        WHERE ID = @id;