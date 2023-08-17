CREATE   PROCEDURE DATATINO_ORCHESTRATOR.UPSERT_SECURITY_PROFILE (
    @id BIGINT NULL,
    @value VARCHAR(200),
    @spt_id BIGINT,
    @active INT = 1
) AS
    IF @id IS NULL
    INSERT DATATINO_ORCHESTRATOR.SECURITY_PROFILES ([VALUE], SPT_ID, ACTIVE ) VALUES (
            @value,
            @spt_id,
            @active)
    ELSE
        UPDATE DATATINO_ORCHESTRATOR.SECURITY_PROFILES SET 
            [VALUE] = @value,
            SPT_ID = @spt_id,
            ACTIVE = @active
        WHERE ID = @id