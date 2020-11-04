-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertProcess] 'Arch_hospital_admissions_per_municipality_dest', 'Archive COVID19 Municipality data from dest table', 'ARCHIVE_TABLES', '[DBO].[SP_HOSPITAL_ADMISSIONS_PER_MUNICIPALITY_ARCHIVE_DEST]', NULL, 'Stored_Procedure', 'NA', 'Execute', 1, 'true';
exec [dbo].[SafeInsertProcess] 'Arch_positive_tested_people_per_municipality_dest', 'Archive positive tested people data from dest table', 'ARCHIVE_TABLES', '[DBO].[SP_POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY_ARCHIVE_DEST]', NULL, 'Stored_Procedure', 'NA', 'Execute', 2, 'true';
exec [dbo].[SafeInsertProcess] 'Arch_results_per_region_dest', 'Archive results per region data from dest table', 'ARCHIVE_TABLES', '[DBO].[SP_RESULTS_PER_REGION_ARCHIVE_DEST]', NULL, 'Stored_Procedure', 'NA', 'Execute', 3, 'true';
go

-- add the 6 already available and active archiving functionalities to this workflow
UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET [ACTIVE]='false'
WHERE WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_CASE_NATIONAL' and NAME = 'DBO.SP_RIVM_COVID_19_CASE_NATIONAL_ARCHIVE_STAGE')

UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET [ACTIVE]='false'
WHERE WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_CASE_NATIONAL' and NAME = 'DBO.SP_RIVM_COVID_19_CASE_NATIONAL_ARCHIVE_INTER')

exec [dbo].[SafeInsertProcess] 'Arch_Stage_RIVM_COVID_19_Case_National', 'Archive Stage Case National data from stage table', 'ARCHIVE_TABLES', 'DBO.SP_RIVM_COVID_19_CASE_NATIONAL_ARCHIVE_STAGE', NULL, 'Stored_Procedure', 'NA', 'Execute', 4, 'true';
exec [dbo].[SafeInsertProcess] 'Arch_Inter_RIVM_COVID_19_Case_National', 'Archive Inter Case National data from inter table', 'ARCHIVE_TABLES', 'DBO.SP_RIVM_COVID_19_CASE_NATIONAL_ARCHIVE_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 5, 'true';


UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET [ACTIVE]='false'
WHERE WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_NUMBER_MUNICIPALITY' and NAME = 'DBO.SP_RIVM_COVID_19_MUNICIPALITY_ARCHIVE_STAGE')

UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET [ACTIVE]='false'
WHERE WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_NUMBER_MUNICIPALITY' and NAME = 'DBO.SP_RIVM_COVID_19_MUNICIPALITY_ARCHIVE_INTER')

exec [dbo].[SafeInsertProcess] 'Arch_Stage_RIVM_Municipality', 'Archive COVID19 Municipality data from stage table', 'ARCHIVE_TABLES', 'DBO.SP_RIVM_COVID_19_MUNICIPALITY_ARCHIVE_STAGE', NULL, 'Stored_Procedure', 'NA', 'Execute', 6, 'true';
exec [dbo].[SafeInsertProcess] 'Arch_Inter_RIVM_Municipality', 'Archive COVID19 Municipality data from inter table', 'ARCHIVE_TABLES', 'DBO.SP_RIVM_COVID_19_MUNICIPALITY_ARCHIVE_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 7, 'true';

UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET [ACTIVE]='false'
WHERE WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE' and NAME = 'DBO.SP_RIVM_COVID_19_MUNICIPALITY_ARCHIVE_STAGE')

UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET [ACTIVE]='false'
WHERE WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE' and NAME = 'DBO.SP_RIVM_COVID_19_MUNICIPALITY_ARCHIVE_INTER')

exec [dbo].[SafeInsertProcess] 'Arch_Stage_RIVM_Municipality_cumulatief', 'Archive COVID19 Municipality cumulatief data from stage table', 'ARCHIVE_TABLES', 'dbo.SP_RIVM_COVID_19_MUNICIPALITY_CUMULATIVE_ARCHIVE_STAGE', NULL, 'Stored_Procedure', 'NA', 'Execute', 8, 'true';
exec [dbo].[SafeInsertProcess] 'Arch_Inter_RIVM_Municipality_cumulatief', 'Archive COVID19 Municipality cumulatief data from inter table', 'ARCHIVE_TABLES', 'dbo.SP_RIVM_COVID_19_MUNICIPALITY_CUMULATIVE_ARCHIVE_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 9, 'true';


-- add new ones
exec [dbo].[SafeInsertProcess] 'Arch_Dest_Sewer_Per_Municipality', 'Archive sewer data per municipality from dest table', 'ARCHIVE_TABLES', '[dbo].[SP_SEWER_MEASUREMENTS_PER_MUNICIPALITY_ARCHIVE_DEST]', NULL, 'Stored_Procedure', 'NA', 'Execute', 10, 'true';
exec [dbo].[SafeInsertProcess] 'Arch_Dest_Deceased_Per_Municipality', 'Archive deceased data per municipality from dest table', 'ARCHIVE_TABLES', '[dbo].[SP_DECEASED_PER_MUNICIPALITY_ARCHIVE_DEST]', NULL, 'Stored_Procedure', 'NA', 'Execute', 11, 'true';
go