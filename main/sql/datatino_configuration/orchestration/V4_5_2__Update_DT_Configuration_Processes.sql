
-- deactivate old rows
UPDATE DATATINO_ORCHESTRATOR.PROCESSES SET [ACTIVE]='false'
WHERE WORKFLOW_ID=(SELECT ID FROM DATATINO_ORCHESTRATOR.WORKFLOWS WHERE WORKFLOW_NAME = 'RIVM_NURSING_HOME_INTAKE')


-- Workflow Nursing Homes (Figures on nursing homes)
exec [dbo].[SafeInsertProcess] 'Load_Nursing_Homes', 'Loads Nursing Home data into target table', 'RIVM_NURSING_HOME_INTAKE', 'Totalen_bewoners_verpleeghuis_per_meldingsdatumGGD_*.csv', 'VWSSTAGE.RIVM_NURSING_HOMES_TOTALS|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 1, 'true';
exec [dbo].[SafeInsertProcess] 'Load_Nursing_Homes', 'Loads Nursing Home data into target table', 'RIVM_NURSING_HOME_INTAKE', 'Sterfte_bewoners_verpleeghuis_per_overlijdensdatum_*.csv', 'VWSSTAGE.RIVM_NURSING_HOMES_DECEASED|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 2, 'true';
exec [dbo].[SafeInsertProcess] 'Load_Nursing_Homes', 'Loads Nursing Home data into target table', 'RIVM_NURSING_HOME_INTAKE', 'Aantal_besmette_verpleeghuis_locaties_per_publicatiedatumRIVM_*.csv', 'VWSSTAGE.RIVM_NURSING_HOMES_INFECTED_LOCATIONS|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 3, 'true';
exec [dbo].[SafeInsertProcess] 'Load_Nursing_Homes', 'Loads Nursing Home data into target table', 'RIVM_NURSING_HOME_INTAKE', 'Totalen_bewoners_gehandicaptenzorginstelling_per_meldingsdatumGGD_*.csv', 'VWSSTAGE.RIVM_NURSING_HOMES_HANDICAPPED_TOTALS|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 4, 'true';
exec [dbo].[SafeInsertProcess] 'Load_Nursing_Homes', 'Loads Nursing Home data into target table', 'RIVM_NURSING_HOME_INTAKE', 'Aantal_besmette_gehandicaptenzorginstelling_locaties_per_publicatiedatumRIVM_*.csv', 'VWSSTAGE.RIVM_NURSING_HOMES_HANDICAPPED_INFECTED_LOCATIONS|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 5, 'true';

exec [dbo].[SafeInsertProcess] 'Load_Nursing_Homes', 'Loads Nursing Home per region data into target table', 'RIVM_NURSING_HOME_INTAKE', 'Totalen_bewoners_verpleeghuis_per_meldingsdatumGGD_naar_veiligheidsregio_*.csv', 'VWSSTAGE.RIVM_NURSING_HOMES_TOTALS_PER_REGION|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 6, 'true';
exec [dbo].[SafeInsertProcess] 'Load_Nursing_Homes', 'Loads Nursing Home per region data into target table', 'RIVM_NURSING_HOME_INTAKE', 'Sterfte_bewoners_verpleeghuis_per_overlijdensdatum_naar_veiligheidsregio_*.csv', 'VWSSTAGE.RIVM_NURSING_HOMES_DECEASED_PER_REGION|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 7, 'true';
exec [dbo].[SafeInsertProcess] 'Load_Nursing_Homes', 'Loads Nursing Home per region data into target table', 'RIVM_NURSING_HOME_INTAKE', 'Aantal_besmette_verpleeghuis_locaties_per_publicatiedatumRIVM_naar_veiligheidsregio_*.csv', 'VWSSTAGE.RIVM_NURSING_HOMES_INFECTED_LOCATIONS_PER_REGION|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 8, 'true';
exec [dbo].[SafeInsertProcess] 'Load_Nursing_Homes', 'Loads Nursing Home per region data into target table', 'RIVM_NURSING_HOME_INTAKE', 'Totalen_bewoners_gehandicaptenzorginstelling_per_meldingsdatumGGD_naar_veiligheidsregio_*.csv', 'VWSSTAGE.RIVM_NURSING_HOMES_HANDICAPPED_TOTALS_PER_REGION|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 9, 'true';
exec [dbo].[SafeInsertProcess] 'Load_Nursing_Homes', 'Loads Nursing Home per region data into target table', 'RIVM_NURSING_HOME_INTAKE', 'Aantal_besmette_gehandicaptenzorginstelling_locaties_per_publicatiedatumRIVM_naar_veiligheidsregio_*.csv', 'VWSSTAGE.RIVM_NURSING_HOMES_HANDICAPPED_INFECTED_LOCATIONS_PER_REGION|;|datafiles|RIVM/', 'NA', 'Blob', 'Ingest', 10, 'true';

-- Stored procedures
exec [dbo].[SafeInsertProcess] 'Inter_Nursing_Homes', 'Move Nursing Home data from stage table to intermediate table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_RIVM_INTAKE_NURSING_HOMES_TOTALS_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 11, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_Nursing_Homes', 'Move Nursing Home data from stage table to intermediate table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_RIVM_INTAKE_NURSING_HOMES_DECEASED_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 12, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_Nursing_Homes', 'Move Nursing Home data from stage table to intermediate table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_RIVM_INTAKE_NURSING_HOMES_INFECTED_LOCATIONS_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 13, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_Nursing_Homes', 'Move Nursing Home data from stage table to intermediate table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_RIVM_INTAKE_NURSING_HOMES_HANDICAPPED_TOTALS_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 14, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_Nursing_Homes', 'Move Nursing Home data from stage table to intermediate table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_RIVM_INTAKE_NURSING_HOMES_HANDICAPPED_INFECTED_LOCATIONS_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 15, 'true';

exec [dbo].[SafeInsertProcess] 'Inter_Nursing_Homes', 'Move Nursing Home per region data from stage table to intermediate table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_RIVM_INTAKE_NURSING_HOMES_TOTALS_PER_REGION_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 16, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_Nursing_Homes', 'Move Nursing Home per region data from stage table to intermediate table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_RIVM_INTAKE_NURSING_HOMES_DECEASED_PER_REGION_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 17, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_Nursing_Homes', 'Move Nursing Home per region data from stage table to intermediate table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_RIVM_INTAKE_NURSING_HOMES_INFECTED_LOCATIONS_PER_REGION_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 18, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_Nursing_Homes', 'Move Nursing Home per region data from stage table to intermediate table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_RIVM_INTAKE_NURSING_HOMES_HANDICAPPED_TOTALS_PER_REGION_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 19, 'true';
exec [dbo].[SafeInsertProcess] 'Inter_Nursing_Homes', 'Move Nursing Home per region data from stage table to intermediate table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_RIVM_INTAKE_NURSING_HOMES_HANDICAPPED_INFECTED_LOCATIONS_PER_REGION_INTER', NULL, 'Stored_Procedure', 'NA', 'Execute', 20, 'true';

exec [dbo].[SafeInsertProcess] 'Dest_Nursing_Homes', 'Move Nursing Home  data from intermediate table to dest table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_NURSING_HOME_TOTALS', NULL, 'Stored_Procedure', 'NA', 'Execute', 21, 'true';
