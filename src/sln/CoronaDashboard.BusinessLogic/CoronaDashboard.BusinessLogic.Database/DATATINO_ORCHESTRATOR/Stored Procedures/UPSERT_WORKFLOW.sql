CREATE   PROCEDURE DATATINO_ORCHESTRATOR.UPSERT_WORKFLOW (
    @id BIGINT NULL,
    @workflow_name VARCHAR(200) NULL,
    @description VARCHAR(200) NULL,
    @schedule VARCHAR(100) NULL,
    @active BIGINT = 1
) AS
    IF @id IS NULL
        INSERT DATATINO_ORCHESTRATOR.WORKFLOWS ([WORKFLOW_NAME], [DESCRIPTION], [SCHEDULE],  [ACTIVE] ) VALUES (
            @workflow_name,
            @description,
            @schedule,
            @active);
    ELSE
        IF @workflow_name IS NULL
            SET @workflow_name = (SELECT [WORKFLOW_NAME] FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE ID = @id)
        IF @description IS NULL
            SET @description = (SELECT [DESCRIPTION] FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE ID = @id)
        IF @schedule IS NULL
            SET @schedule = (SELECT [SCHEDULE] FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE ID = @id)
        IF @active IS NULL
            SET @active = (SELECT [ACTIVE] FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE ID = @id)
        UPDATE DATATINO_ORCHESTRATOR.WORKFLOWS SET 
            [WORKFLOW_NAME] = @workflow_name,
            [DESCRIPTION] = @description,
            [SCHEDULE] = @schedule,
            [ACTIVE] = @active
        WHERE ID = @id