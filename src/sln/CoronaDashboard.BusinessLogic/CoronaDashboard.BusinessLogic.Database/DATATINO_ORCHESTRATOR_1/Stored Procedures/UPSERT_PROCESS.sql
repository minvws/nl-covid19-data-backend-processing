CREATE   PROCEDURE [DATATINO_ORCHESTRATOR_1].[UPSERT_PROCESS] (
    @id BIGINT NULL,
    @process_name VARCHAR(MAX) NULL, 
    @description VARCHAR(MAX) NULL, 
    @source_name VARCHAR(MAX) NULL, 
    @schedule VARCHAR(MAX) NULL,
    @workflow_name VARCHAR(MAX) NULL, 
    @active INT = 1
) AS
    DECLARE @source_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR_1.SOURCES WHERE [NAME] = @source_name)
    DECLARE @workflow_id bigint = ( SELECT [ID] FROM DATATINO_ORCHESTRATOR_1.WORKFLOWS WHERE DATAFLOW_ID = (SELECT ID FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE [NAME] = @workflow_name))
    IF @id IS NULL
    BEGIN
        INSERT DATATINO_ORCHESTRATOR_1.DATAFLOWS([NAME], [DESCRIPTION], [DATAFLOW_TYPE_ID])
        VALUES (
            @process_name,
            @description,
            2
        );

        INSERT DATATINO_ORCHESTRATOR_1.PROCESSES ([DATAFLOW_ID], [DATAFLOW_TYPE_ID], [SOURCE_ID], [WORKFLOW_ID], [SCHEDULE],  [ACTIVE] ) 
        VALUES (
            (SELECT [ID] FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE [NAME] = @process_name),
            2,
            @source_id,
            @workflow_id,
            @schedule,
            @active
        );
    END
    ELSE
        IF @process_name IS NULL
            SET @process_name = (SELECT [NAME] FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE ID = (SELECT DATAFLOW_ID FROM DATATINO_ORCHESTRATOR_1.WORKFLOWS WHERE [ID] = @id))
        IF @description IS NULL
            SET @description = (SELECT [DESCRIPTION] FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE ID = (SELECT DATAFLOW_ID FROM DATATINO_ORCHESTRATOR_1.WORKFLOWS WHERE [ID] = @id))
        IF @workflow_id IS NULL
            SET @workflow_id = (SELECT [WORKFLOW_ID] FROM DATATINO_ORCHESTRATOR_1.PROCESSES WHERE [ID] = @id)
        IF @source_id IS NULL
            SET @source_id = (SELECT [SOURCE_ID] FROM DATATINO_ORCHESTRATOR_1.PROCESSES WHERE [ID] = @id)
        IF @active IS NULL
            SET @active = (SELECT [ACTIVE] FROM DATATINO_ORCHESTRATOR_1.PROCESSES WHERE [ID] = @id)
        UPDATE DATATINO_ORCHESTRATOR_1.PROCESSES SET 
            [SOURCE_ID] = @source_id,
            [WORKFLOW_ID] = @workflow_id,
            [SCHEDULE] = @schedule,
            [ACTIVE] = @active
        WHERE ID = @id

        UPDATE DATATINO_ORCHESTRATOR_1.DATAFLOWS SET
            [NAME] = @process_name,
            [DESCRIPTION] = @description
        WHERE ID = (SELECT [ID] FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE [NAME] = @process_name)