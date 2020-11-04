-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

-- Add one process to the Workflow Casus Landelijk (National figures COVID19)

-- update the execution order of the archiving functionality, so the stored procedure happens first
UPDATE DATATINO_ORCHESTRATOR.PROCESSES
    SET [EXEC_ORDER]= 6
    WHERE PROCESS_NAME = 'Arch_Stage_RIVM_COVID_19_Case_National'
    AND [EXEC_ORDER]= 4
    AND WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_CASE_NATIONAL');

-- add the process step to the workflow
exec [dbo].[SafeInsertProcess] 'Dest_RIVM_COVID_19_Case_National_Per_Small_Agegroup', 'Move Case National data from intermediate table to dest table with the smaller age-group-ranges', 'RIVM_COVID_19_CASE_NATIONAL', 'DBO.SP_POSITIVE_TESTED_PEOPLE_PER_SMALL_AGE_GROUP', NULL, 'Stored_Procedure', 'NA', 'Execute', 4, 'true';

GO