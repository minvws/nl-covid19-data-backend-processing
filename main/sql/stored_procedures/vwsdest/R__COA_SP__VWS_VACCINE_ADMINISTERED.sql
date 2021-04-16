-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Attention: if new vaccine providers come this query must be edited. Dynamic SQL is rather cumbersome and the frontend expects a fixed
-- set of providers anyway.
CREATE OR ALTER PROCEDURE [dbo].[SP_VWS_VACCINE_ADMINISTERED_DEST]
AS
BEGIN
WITH BASE_CTE AS
(
SELECT [DATE_FIRST_DAY]
      ,[VALUE_TYPE]
      ,[VALUE_NAME]
      ,[REPORT_STATUS]
      ,[VALUE]
  FROM [VWSINTER].[VWS_VACCINE_DELIVERIES_ADMINISTERED]
  WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[VWS_VACCINE_DELIVERIES_ADMINISTERED]) 
    AND VALUE_TYPE = 'vaccine_administered' 
)
,
PIVOT_CTE AS
(
    SELECT 
         [AstraZeneca], [BioNTech/Pfizer], [CureVac], [Janssen], [Moderna], [Sanofi] 
        ,[DATE_FIRST_DAY]
        ,[VALUE_TYPE]
        ,[REPORT_STATUS]
    FROM   BASE_CTE
    PIVOT  
    (  
        SUM ([VALUE])  
        FOR VALUE_NAME IN  
            ( [AstraZeneca],[BioNTech/Pfizer],[CureVac],[Janssen],[Moderna],[Sanofi] 
            )  
    ) AS pvt  
)
INSERT INTO VWSDEST.VWS_VACCINE_ADMINISTERED
(
   [AstraZeneca]      
  ,[BioNTech/Pfizer]  
  ,[CureVac]          
  ,[Janssen]          
  ,[Moderna]          
  ,[Sanofi]           
  ,[DATE_FIRST_DAY]  
  ,DATE_START_UNIX    
  ,DATE_END_UNIX      
  ,[VALUE_TYPE]      
  ,[REPORT_STATUS]   
)
SELECT  
         ISNULL([AstraZeneca]        ,0) AS [AstraZeneca]    
        ,ISNULL([BioNTech/Pfizer]    ,0) AS [BioNTech/Pfizer]
        ,ISNULL([CureVac]            ,0) AS [CureVac]        
        ,ISNULL([Janssen]            ,0) AS [Janssen]        
        ,ISNULL([Moderna]            ,0) AS [Moderna]        
        ,ISNULL([Sanofi]             ,0) AS [Sanofi]         
        ,[DATE_FIRST_DAY]
        ,[dbo].[CONVERT_DATETIME_TO_UNIX]([DATE_FIRST_DAY])                 AS DATE_START_UNIX
        ,[dbo].[CONVERT_DATETIME_TO_UNIX](DATEADD(DAY,6,[DATE_FIRST_DAY]))  AS DATE_END_UNIX
        ,[VALUE_TYPE]
        ,[REPORT_STATUS]
FROM PIVOT_CTE
  ORDER BY DATE_FIRST_DAY
END;
