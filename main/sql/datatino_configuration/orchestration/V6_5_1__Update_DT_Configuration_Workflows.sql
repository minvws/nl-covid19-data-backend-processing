-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Note: even though triggers are not per session, updating the value within a transaction will ensure the table is locked.

BEGIN TRANSACTION;
DISABLE TRIGGER DATATINO_ORCHESTRATOR.tUpdateWorkflowTimeToRun
ON DATATINO_ORCHESTRATOR.WORKFLOWS

UPDATE DATATINO_ORCHESTRATOR.WORKFLOWS 
    SET INTERVAL_ID = (SELECT ID FROM DATATINO_ORCHESTRATOR.INTERVALS WHERE NAME='Day')
WHERE WORKFLOW_NAME = 'RIVM_SEWER_MEASUREMENTS';

ENABLE TRIGGER DATATINO_ORCHESTRATOR.tUpdateWorkflowTimeToRun
ON DATATINO_ORCHESTRATOR.WORKFLOWS
COMMIT;