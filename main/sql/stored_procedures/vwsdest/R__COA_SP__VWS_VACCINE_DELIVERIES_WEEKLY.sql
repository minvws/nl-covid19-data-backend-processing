-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER PROCEDURE [dbo].[SP_VWS_VACCINE_DELIVERIES_WEEKLY]
AS
BEGIN
WITH BASE_CTE AS
(
SELECT [DATE_FIRST_DAY]
      ,DATE_OF_REPORT
      ,[VALUE_TYPE]
      ,[VALUE_NAME]
      ,[REPORT_STATUS]
      ,[VALUE]
  FROM [VWSINTER].[VWS_VACCINE_DELIVERIES_ADMINISTERED]
  WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[VWS_VACCINE_DELIVERIES_ADMINISTERED]) 
    AND VALUE_TYPE = 'vaccine_delivery_weekly' 
)
,
TOTAL_CTE AS (
SELECT [DATE_FIRST_DAY]
      ,[VALUE_TYPE]
      ,SUM([VALUE]) AS [TOTAL_VALUE]
  FROM [BASE_CTE]
    GROUP BY VALUE_TYPE, DATE_FIRST_DAY
)
,
PIVOT_CTE AS
(
    SELECT 
         [AstraZeneca], [BioNTech/Pfizer], [CureVac], [Janssen], [Moderna], [Sanofi] 
        ,[DATE_FIRST_DAY]
        ,[DATE_OF_REPORT]
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
INSERT INTO VWSDEST.VWS_VACCINE_DELIVERIES_WEEKLY
(
   [AstraZeneca]      
  ,[BioNTech/Pfizer]  
  ,[CureVac]          
  ,[Janssen]          
  ,[Moderna]          
  ,[Sanofi]           
  ,TOTAL_VALUE
  ,[DATE_FIRST_DAY]  
  ,DATE_OF_REPORT
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
        ,T2.TOTAL_VALUE
        ,T1.[DATE_FIRST_DAY]
        ,T1.DATE_OF_REPORT
        ,[dbo].[CONVERT_DATETIME_TO_UNIX](T1.[DATE_FIRST_DAY])                 AS DATE_START_UNIX
        ,[dbo].[CONVERT_DATETIME_TO_UNIX](DATEADD(DAY,6,T1.[DATE_FIRST_DAY]))  AS DATE_END_UNIX
        ,T1.[VALUE_TYPE]
        ,T1.[REPORT_STATUS]
FROM PIVOT_CTE T1
  LEFT JOIN TOTAL_CTE T2 ON T1.[DATE_FIRST_DAY] = T2.[DATE_FIRST_DAY] AND T1.[VALUE_TYPE] = T2.[VALUE_TYPE]
  ORDER BY DATE_FIRST_DAY

END;
