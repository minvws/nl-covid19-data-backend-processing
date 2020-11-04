-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.



-- Disable old municipality processes so that only the new data will be inserted into dest tables.
UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET ACTIVE='false' WHERE PROCESS_NAME='Dest_Positive_Tested_People' AND WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE')
UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET ACTIVE='false' WHERE PROCESS_NAME='Dest_Hospital_Admissions' AND WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE')
UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET ACTIVE='false' WHERE PROCESS_NAME='Dest_Results_Per_Region' AND WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE')
UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET ACTIVE='false' WHERE PROCESS_NAME='Dest_Positive_Tested_People_Per_Municipality' AND WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE')
UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET ACTIVE='false' WHERE PROCESS_NAME='Dest_Hospital_Admissions_Per_Municipality' AND WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE')

-- Update stored procedure name of old municipality inter function
UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET [NAME]='DBO.SP_RIVM_COVID_19_MUNICIPALITY_CUMULATIVE_INTER' WHERE PROCESS_NAME = 'Inter_RIVM_Municipality' AND WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE')

-- New workflow Casus Gemeente non-cumulative values
exec [dbo].[SafeInsertProcess] 'Load_RIVM_Municipality_new', 'Loads COVID19 Municipality data into target table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY', 'https://data.rivm.nl/covid-19/COVID-19_aantallen_gemeente_per_dag.json', 'VWSSTAGE.RIVM_COVID_19_NUMBER_MUNICIPALITY', 'NA', 'Web', 'Ingest', 1, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_RIVM_Municipality_new', 'Move COVID19 Municipality data from stage table to intermediate table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY', 'DBO.SP_RIVM_COVID_19_MUNICIPALITY_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2, 'true';
exec [dbo].[SafeInsertProcess] 'Dest_Positive_Tested_People_new', 'Move COVID19 Municipality data from intermediate table to dest table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY', 'DBO.SP_POSITIVE_TESTED_PEOPLE', NULL, 'Stored_Procedure', 'NA', 'Execute', 3, 'true';
exec [dbo].[SafeInsertProcess] 'Dest_Hospital_Admissions_new', 'Move COVID19 Municipality data from intermediate table to dest table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY', 'DBO.SP_HOSPITAL_ADMISSIONS', NULL, 'Stored_Procedure', 'NA', 'Execute', 4, 'true';
exec [dbo].[SafeInsertProcess] 'Dest_Results_Per_Region_new', 'Move COVID19 Municipality from intermediate table to dest table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY', 'DBO.SP_RESULTS_PER_REGION', NULL, 'Stored_Procedure', 'NA', 'Execute', 5, 'true';
exec [dbo].[SafeInsertProcess] 'Dest_Positive_Tested_People_Per_Municipality_new', 'Move COVID19 Municipality from intermediate table to dest table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY', 'DBO.SP_POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY', NULL, 'Stored_Procedure', 'NA', 'Execute', 6, 'true';
exec [dbo].[SafeInsertProcess] 'Dest_Hospital_Admissions_Per_Municipality_new', 'Move COVID19 Municipality from intermediate table to dest table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY', 'DBO.SP_HOSPITAL_ADMISSIONS_PER_MUNICIPALITY', NULL, 'Stored_Procedure', 'NA', 'Execute', 7, 'true';
exec [dbo].[SafeInsertProcess] 'Arch_Stage_RIVM_Municipality_new', 'Archive COVID19 Municipality data from dest table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY', 'DBO.SP_RIVM_COVID_19_MUNICIPALITY_ARCHIVE_STAGE', NULL, 'Stored_Procedure', 'NA', 'Execute', 8, 'true';
exec [dbo].[SafeInsertProcess] 'Arch_Inter_RIVM_Municipality_new', 'Archive COVID19 Municipality data from dest table', 'RIVM_COVID_19_NUMBER_MUNICIPALITY', 'DBO.SP_RIVM_COVID_19_MUNICIPALITY_ARCHIVE_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 9, 'true';

-- Workflow positive tested people percentage
exec [dbo].[SafeInsertProcess] 'Load_Percentage_Positive_Tested_People', 'Loads positive tested people percentage data into target table', 'GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE', 'COV-19_teststraten_*.csv', 'VWSSTAGE.GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 1, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_Percentage_Positive_Tested_People', 'Move positive tested people percentage data from stage table to intermediate table', 'GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE', 'DBO.SP_GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2, 'true';
exec [dbo].[SafeInsertProcess] 'Dest_Positive_Tested_People_Percentage', 'Move positive tested people percentage data from intermediate table to dest table', 'GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE', 'DBO.SP_POSITIVE_TESTED_PEOPLE_PERCENTAGE', NULL, 'Stored_Procedure', 'NA', 'Execute', 3, 'true';

-- Workflow escalation
exec [dbo].[SafeInsertProcess] 'Load_Coronalevels_per_region', 'Loads Escalation data into target table', 'VWS_CORONALEVEL_REGIONS', 'Coronaniveau_veiligheidsregios_*.csv', 'VWSSTAGE.VWS_CORONALEVEL_REGIONS|;|datafiles|VWS/', 'NA', 'Blob', 'Ingest', 1, 'true';
exec [dbo].[SafeInsertProcess] 'Dest_Escalationlevels_per_region', 'Move Escalation data from intermediate table to dest table', 'VWS_CORONALEVEL_REGIONS', 'DBO.SP_ESCALATIONLEVELS_PER_REGION', NULL, 'Stored_Procedure', 'NA', 'Execute', 2, 'true';

GO