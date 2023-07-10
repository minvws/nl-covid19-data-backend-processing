CREATE    VIEW [dbo].[V_STATIC_FILES] AS 
 SELECT  
     s.DOCUMENT_NAME as DocumentName,
     s.BASE_URL AS BaseUrl,
     s.TABLE_NAME AS TableName,
     s.TABLE_SCHEMA AS TableSchema,
     dbo.Create_Adf_Mapping(s.[SOURCE_COLUMNS], s.[TARGET_COLUMNS]) AS Mapping
   FROM [VWSSTATIC].[SPLIT_FILE_SOURCES] s
 /*
 CREATE  OR ALTER VIEW [dbo].[V_STATIC_FILES] AS 
 SELECT  
     'COVID-19_aantallen_gemeente_per_dag.csv' as DocumentName,
     'https://data.rivm.nl/covid-19/' AS BaseUrl,
     'RIVM_COVID_19_NUMBER_MUNICIPALITY' AS TableName,
     'VWSSTATIC' AS TableSchema,
     dbo.CreateAdfMapping(s.[SOURCE_COLUMNS], s.[TARGET_COLUMNS]) AS Mapping
   FROM [DATATINO_ORCHESTRATOR_1].[SOURCES] s
   INNER JOIN [VWSSTATIC].[SPLIT_FILE_SOURCES] sfs ON s.Id = sfs.source_id
 */