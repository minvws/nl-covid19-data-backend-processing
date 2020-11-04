-- deactivate old row
UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET [ACTIVE]='false'
WHERE WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_COVID_19_NUMBER_MUNICIPALITY')
AND [NAME] = 'Dest_Hospital_Admissions_new'
AND [ARGS] = 'DBO.SP_HOSPITAL_ADMISSIONS'

-- Workflow Stichting Nice Hospital Admissions
exec [dbo].[SafeInsertProcess] 'Load_NICE_Hospital_Admissions', 'Loads Foundation Nice data into target table', 'NICE_HOSPITAL_ADMISSIONS_NATIONAL', 'https://www.stichting-nice.nl/covid-19/public/zkh/new-intake/confirmed', 'VWSSTAGE.NICE_HOSPITAL_ADMISSIONS_NATIONAL', 'NA', 'Web', 'Ingest', 1, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_NICE_Hospital_Admissions', 'Move Foundation Nice data from stage table to intermediate table', 'NICE_HOSPITAL_ADMISSIONS_NATIONAL', 'DBO.SP_NICE_HOSPITAL_ADMISSIONS_NATIONAL_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2, 'true';
exec [dbo].[SafeInsertProcess] 'Dest_NICE_Hospital_Admissions', 'Move Foundation Nice data from intermediate table to dest table', 'NICE_HOSPITAL_ADMISSIONS_NATIONAL', 'DBO.SP_HOSPITAL_ADMISSIONS_NICE', NULL, 'Stored_Procedure', 'NA', 'Execute', 3, 'true';

-- deactivate old rows
UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET [ACTIVE]='false'
WHERE WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'LNAZ_HOSPITAL_BED_OCCUPANCY')


-- Workflow Bed Occupancy
exec [dbo].[SafeInsertProcess] 'Load_Hospital_Bed_Occupancy', 'Loads bed occupancy data into target table', 'LNAZ_HOSPITAL_BED_OCCUPANCY', 'https://lcps.nu/wp-content/uploads/covid-19.csv', 'VWSSTAGE.LNAZ_HOSPITAL_BED_OCCUPANCY|,', 'NA', 'Web', 'Ingest', 1, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_Hospital_Bed_Occupancy', 'Move bed occupancy data from stage table to intermediate table', 'LNAZ_HOSPITAL_BED_OCCUPANCY', 'dbo.SP_LNAZ_HOSPITAL_BED_OCCUPANCY_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 2, 'true';
exec [dbo].[SafeInsertProcess] 'Dest_Hospital_Bed_Occupancy', 'Move bed occupancy data from intermediate table to dest table', 'LNAZ_HOSPITAL_BED_OCCUPANCY', 'dbo.SP_HOSPITAL_BED_OCCUPANCY', NULL, 'Stored_Procedure', 'NA', 'Execute', 3, 'true';