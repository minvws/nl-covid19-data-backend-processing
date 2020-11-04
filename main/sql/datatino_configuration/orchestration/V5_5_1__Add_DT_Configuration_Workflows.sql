-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertWorkflow] 'ARCHIVE_TABLES', 'Day', '8:17', 'N', 'true';
go

-- update the reindexing to run at the different time
-- Note: even though triggers are not per session, updating the value within a transaction will ensure the table is locked.

BEGIN TRANSACTION;
DISABLE TRIGGER DATATINO_ORCHESTRATOR.tUpdateWorkflowTimeToRun
ON DATATINO_ORCHESTRATOR.WORKFLOWS

UPDATE DATATINO_ORCHESTRATOR.WORKFLOWS set TIME_TO_RUN = CAST(CAST(GETDATE() AS DATE) AS DATETIME) + CAST('10:17' AS DATETIME) where WORKFLOW_NAME = 'REINDEX_TABLES';

ENABLE TRIGGER DATATINO_ORCHESTRATOR.tUpdateWorkflowTimeToRun
ON DATATINO_ORCHESTRATOR.WORKFLOWS
COMMIT;