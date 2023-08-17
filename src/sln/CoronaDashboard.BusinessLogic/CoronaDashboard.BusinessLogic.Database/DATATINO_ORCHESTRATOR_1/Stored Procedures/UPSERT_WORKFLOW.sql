CREATE   PROCEDURE [DATATINO_ORCHESTRATOR_1].[UPSERT_WORKFLOW] (
    @id BIGINT NULL,
    @workflow_name VARCHAR(200) NULL,
    @description VARCHAR(200) NULL,
    @schedule VARCHAR(100) NULL,
    @active BIGINT = 1
) AS
    IF @id IS NULL
    BEGIN
        INSERT DATATINO_ORCHESTRATOR_1.DATAFLOWS([NAME], [DESCRIPTION], [DATAFLOW_TYPE_ID])
        VALUES (
            @workflow_name,
            @description,
            1
        );
    
        INSERT DATATINO_ORCHESTRATOR_1.WORKFLOWS ([DATAFLOW_ID], [DATAFLOW_TYPE_ID], [SCHEDULE],  [ACTIVE] ) 
        VALUES (
            (SELECT [ID] FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE [NAME] = @workflow_name),
            1,
            @schedule,
            @active
        );
    END
    ELSE
        IF @workflow_name IS NULL
            SET @workflow_name = (SELECT [NAME] FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE ID = @id)
        IF @description IS NULL
            SET @description = (SELECT [DESCRIPTION] FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE ID = @id)
        IF @schedule IS NULL
            SET @schedule = (SELECT [SCHEDULE] FROM DATATINO_ORCHESTRATOR_1.WORKFLOWS WHERE ID = @id)
        IF @active IS NULL
            SET @active = (SELECT [ACTIVE] FROM DATATINO_ORCHESTRATOR_1.WORKFLOWS WHERE ID = @id)
        UPDATE DATATINO_ORCHESTRATOR_1.WORKFLOWS SET 
            [SCHEDULE] = @schedule,
            [ACTIVE] = @active
        WHERE ID = @id

        UPDATE DATATINO_ORCHESTRATOR_1.DATAFLOWS SET
            [NAME] = @workflow_name,
            [DESCRIPTION] = @description
        WHERE ID = (SELECT [ID] FROM DATATINO_ORCHESTRATOR_1.DATAFLOWS WHERE [NAME] = @workflow_name)