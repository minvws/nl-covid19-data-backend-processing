﻿CREATE   PROCEDURE DATATINO_ORCHESTRATOR.UPSERT_PROCESS_HISTORY (
    @id BIGINT,
    @status VARCHAR(5),
    @last_run DATETIME2
) AS
    UPDATE [DATATINO_ORCHESTRATOR].[PROCESSES]
    SET [LAST_RUN] = @last_run
    WHERE ID = @id
    
    DECLARE @process_name varchar(200) = ( SELECT [PROCESS_NAME] FROM DATATINO_ORCHESTRATOR.PROCESSES WHERE [ID] = @id)
    DECLARE @status_id int = ( SELECT CASE WHEN UPPER(@status) = 'TRUE' THEN 1 ELSE 0 END)
    INSERT INTO [DATATINO_ORCHESTRATOR].[H_PROCESSES]
    ([IDENTIFIER], [PROCESS_NAME], [LAST_RUN], [STATUS])
    VALUES(@id, @process_name, @last_run, @status_id)