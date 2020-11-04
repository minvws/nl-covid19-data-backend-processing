-- insert process for regional nursing home data
exec [dbo].[SafeInsertProcess] 'Dest_Nursing_Homes_Regional', 'Move Nursing Home regional data from intermediate table to dest table', 'RIVM_NURSING_HOME_INTAKE', 'DBO.SP_NURSING_HOMES_PER_REGION', NULL, 'Stored_Procedure', 'NA', 'Execute', 22, 'true';
