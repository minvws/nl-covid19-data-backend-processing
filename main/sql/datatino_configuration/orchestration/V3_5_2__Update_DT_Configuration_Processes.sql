-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

-- bugfix for deceased nursing homes
UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET [NAME]='Sterfte_VPH_bewoners_per_overlijdensdatum_*.csv'
WHERE PROCESS_NAME='Load_Nursing_Homes'
AND WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_NURSING_HOME_INTAKE')
AND [NAME] = 'Sterfte_VPH_bewoners_per_overlijdensdatum_*.csv'

-- Workflow positive tested people percentage per region
exec [dbo].[SafeInsertProcess] 'Load_Percentage_Positive_Tested_People_Per_Region', 'Loads positive tested people per region percentage data into target table', 'GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE_PER_REGION', 'COV-19_teststraten_veiligheidsregio_*.csv', 'VWSSTAGE.GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE_PER_REGION|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 1, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_Percentage_Positive_Tested_People_Per_Region', 'Move positive tested people per region percentage data from stage table to intermediate table', 'GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE_PER_REGION', 'DBO.SP_GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE_PER_REGION_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2, 'true';
exec [dbo].[SafeInsertProcess] 'Dest_Positive_Tested_People_Percentage_Per_Region', 'Move positive tested people per region percentage data from intermediate table to dest table', 'GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE_PER_REGION', 'DBO.SP_POSITIVE_TESTED_PEOPLE_PERCENTAGE_PER_REGION', NULL, 'Stored_Procedure', 'NA', 'Execute', 3, 'true';

GO