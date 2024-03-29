﻿CREATE   PROCEDURE DATATINO_ORCHESTRATOR.UPDATE_PROCESS_HISTORY  (
    @id BIGINT,
    @status INT,
    @scheduled_run INT NULL
) AS
    DECLARE @process_name VARCHAR(MAX) = (SELECT PROCESS_NAME FROM DATATINO_ORCHESTRATOR.PROCESSES WHERE ID = @id)

    INSERT DATATINO_ORCHESTRATOR.H_PROCESSES (IDENTIFIER, PROCESS_NAME, LAST_RUN, STATUS) VALUES (
        @id,
        @process_name,
        GETDATE(),
        @status);