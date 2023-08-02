-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.
     
 -- 1) CREATE STORE PROCEDURE(S) INTER -> DEST.....
 CREATE   PROCEDURE [dbo].[SP_VWS_VACCINE_ADMINISTERED_DEST]
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
          [AstraZeneca], [BioNTech/Pfizer], [CureVac], [Janssen], [Moderna], [Sanofi], [Novavax] 
         ,[DATE_FIRST_DAY]
         ,[VALUE_TYPE]
         ,[REPORT_STATUS]
     FROM   BASE_CTE
     PIVOT  
     (  
         SUM ([VALUE])  
         FOR VALUE_NAME IN  
             ( [AstraZeneca],[BioNTech/Pfizer],[CureVac],[Janssen],[Moderna],[Sanofi], [Novavax] 
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
   ,[Novavax]
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
         ,ISNULL([Novavax]            ,0) AS [Novavax]
         ,[DATE_FIRST_DAY]
         ,[dbo].[CONVERT_DATETIME_TO_UNIX]([DATE_FIRST_DAY])                 AS DATE_START_UNIX
         ,[dbo].[CONVERT_DATETIME_TO_UNIX](DATEADD(DAY,6,[DATE_FIRST_DAY]))  AS DATE_END_UNIX
         ,[VALUE_TYPE]
         ,[REPORT_STATUS]
 FROM PIVOT_CTE
   ORDER BY DATE_FIRST_DAY
 END;