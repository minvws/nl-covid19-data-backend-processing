﻿CREATE   PROCEDURE [dbo].[SP_CBS_POPULATION_BASE_STATIC]
 AS
 BEGIN
 /*
 	POPULATION_BASE is transferred from STAGE to STATIC,
 	the table RECLASSIFIED_MUNICIPALITY_MAPPING is used to apply changes
 	in the municipalities.
 	
 	The RECLASSIFIED_MUNICIPALITY_MAPPING table is left-joined, so only
 	municipalities that met with a change will be affected.
 	Only changes that are 'active' are selected.
 */
  -- POPULATION_BASE IS TRANSFERRED FROM STAGE TO STATIC, THE TABLE RECODE_MUNICIPALITY IS USED TO APPLY CHANGES IN THE MUNICIPALITIES.
  -- THE RECODE_MUNICIPALITY TABLE IS LEFT-JOINED, SO ONLY MUNICIPALITIES THAT MET WITH A CHANGE WILL BE AFFECTED. 
  -- ONLY CHANGES THAT ARE 'ACTIVE' ARE SELECTED.
  INSERT INTO [VWSSTATIC].[CBS_POPULATION_BASE] (
      [GEMEENTE_CODE]
      ,[GEMEENTE]
      ,[LEEFTIJD]
      ,[GESLACHT]
      ,[DATUM_PEILING]
      ,[POPULATIE]
      ,[VEILIGHEIDSREGIO_CODE]
      ,[VEILIGHEIDSREGIO_NAAM]
      ,[PROVINCIE_CODE]
      ,[PROVINCIE_NAAM]
      ,[GGD_CODE]
      ,[GGD_NAAM]
  )
  SELECT 
      ISNULL(B.[GM_CODE_NEW],[GEMEENTE_CODE]) AS [GEMEENTE_CODE]
      ,ISNULL(B.[GM_NAME_NEW],[GEMEENTE]) AS [GEMEENTE]
      ,A.[LEEFTIJD]
      ,A.[GESLACHT]
      ,CAST(A.[DATUM_PEILING] AS DATE) AS [DATUM_PEILING]
      ,ROUND(SUM(CAST(A.[POPULATIE] AS INT) * ISNULL(B.[SHARES],1.0)),0) AS [POPULATIE] 
      ,ISNULL(B.[VR_CODE],[VEILIGHEIDSREGIO_CODE]) AS [VEILIGHEIDSREGIO_CODE]
      ,ISNULL(B.[VR_NAME],[VEILIGHEIDSREGIO_NAAM]) AS [VEILIGHEIDSREGIO_NAAM]
      ,ISNULL(B.[PROVINCE_CODE],[PROVINCIE_CODE]) AS [PROVINCIE_CODE]
      ,ISNULL(B.[PROVINCE_NAME],[PROVINCIE_NAAM]) AS [PROVINCIE_NAAM]
      ,ISNULL(B.[GGD_CODE], A.[GGD_CODE]) AS [GGD_CODE]
      ,ISNULL(B.[GGD_NAME],[GGD_NAAM]) AS [GGD_NAAM]
  FROM [VWSSTAGE].[CBS_POPULATION_BASE] A
      LEFT JOIN (
          SELECT 
              * 
          FROM [VWSSTATIC].[RECLASSIFIED_MUNICIPALITY_MAPPING] 
          WHERE [ACTIVE] = 1 
              AND [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTATIC].[RECLASSIFIED_MUNICIPALITY_MAPPING])  
      ) B ON A.[GEMEENTE_CODE] = B.[GM_CODE_ORIGINAL]
  WHERE A.[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].[CBS_POPULATION_BASE])
  GROUP BY
      ISNULL(B.[GM_CODE_NEW],[GEMEENTE_CODE]) 
      ,ISNULL(B.[GM_NAME_NEW],[GEMEENTE]) 
      ,A.[LEEFTIJD]
      ,A.[GESLACHT]
      ,CAST(A.[DATUM_PEILING] AS DATE) 
      ,ISNULL(B.[VR_CODE],[VEILIGHEIDSREGIO_CODE]) 
      ,ISNULL(B.[VR_NAME],[VEILIGHEIDSREGIO_NAAM]) 
      ,ISNULL(B.[PROVINCE_CODE],[PROVINCIE_CODE]) 
      ,ISNULL(B.[PROVINCE_NAME],[PROVINCIE_NAAM]) 
      ,ISNULL(B.[GGD_CODE],A.[GGD_CODE]) 
      ,ISNULL(B.[GGD_NAME],[GGD_NAAM]) 
  ORDER BY [DATUM_PEILING], ISNULL(B.[GM_CODE_NEW],[GEMEENTE_CODE])
  END