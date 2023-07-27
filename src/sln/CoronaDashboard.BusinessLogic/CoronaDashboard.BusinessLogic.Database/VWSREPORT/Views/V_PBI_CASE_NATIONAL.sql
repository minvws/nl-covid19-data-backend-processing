-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSREPORT.V_PBI_CASE_NATIONAL AS
	SELECT 
       CAST([DATE_STATISTICS] as date)					AS [Datum]
       ,CAST([DATE_LAST_INSERTED] as date)      AS [Update datum]
      ,[AGEGROUP]										            AS [Leeftijdsgroep]
      ,CASE 
        WHEN [SEX] = 'Male' THEN 'Man'
        WHEN [SEX] = 'Female' THEN 'Vrouw'
        ELSE 'Onbekend'
      END   											              AS [Geslacht]
      ,[PROVINCE]										            AS [Provincie]     
      ,[MUNICIPAL_HEALTH_SERVICE]						    AS [GGD]
      ,COUNT(*)                                 AS [Positieve testen]
      ,SUM(
        CASE 
          WHEN Deceased = 'Yes' 
          THEN 1 
          ELSE 0 
        END)                                    AS [Sterfte]
  
  FROM 
    [VWSINTER].[RIVM_COVID_19_CASE_NATIONAL]
  WHERE 
	  DATE_LAST_INSERTED = 
      (SELECT 
        MAX(DATE_LAST_INSERTED) 
      FROM [VWSINTER].[RIVM_COVID_19_CASE_NATIONAL])
  GROUP BY
     CAST([DATE_STATISTICS] as date)
     ,CAST(DATE_LAST_INSERTED as date)
      ,[AGEGROUP]
      ,CASE 
        WHEN [SEX] = 'Male' THEN 'Man'
        WHEN [SEX] = 'Female' THEN 'Vrouw'
        ELSE 'Onbekend'
      END   									
      ,[PROVINCE]		
      ,[MUNICIPAL_HEALTH_SERVICE]