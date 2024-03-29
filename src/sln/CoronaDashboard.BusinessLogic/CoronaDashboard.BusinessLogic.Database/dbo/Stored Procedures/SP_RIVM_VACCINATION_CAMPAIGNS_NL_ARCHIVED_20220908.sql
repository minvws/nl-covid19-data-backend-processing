﻿-- Hiervoor eenmalig een query runnen die dit INTO een VWSARCHIVE tabel schrijft
 -- met als extensie 20220908 en die filtert op de datum 2022-0908
 
 
 -- 1) CREATE STORED PROCEDURE(S): ARCHIVE EXISTING DATA
 CREATE   PROCEDURE [dbo].[SP_RIVM_VACCINATION_CAMPAIGNS_NL_ARCHIVED_20220908]
 AS
 BEGIN
 
 TRUNCATE TABLE [VWSARCHIVE].[RIVM_VACCINATION_CAMPAIGNS_NL_ARCHIVED_20220908];
 
 WITH CTE AS (
     SELECT
             [DATE_LAST_INSERTED],
             [DATE_OF_REPORT],
             [DATE_OF_STATISTICS],
             [CAMPAIGN],
             [TOTAL_VACCINATED],
             [CUMSUM_TOTAL_VACCINATED],
             [TOTAL_VACCINATED_7DAYS]
     FROM [VWSDEST].[RIVM_VACCINATION_CAMPAIGNS_NL] WITH(NOLOCK)
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_VACCINATION_CAMPAIGNS_NL])
     )
 INSERT INTO VWSARCHIVE.RIVM_VACCINATION_CAMPAIGNS_NL_ARCHIVED_20220908 (
     VACCINE_CAMPAIGN_ORDER,
     VACCINE_CAMPAIGN_NAME_NL,
     VACCINE_CAMPAIGN_NAME_EN,
     VACCINE_ADMINISTERED_TOTAL,
     VACCINE_ADMINISTERED_LAST_WEEK,
     DATE_UNIX,
     DATE_END_UNIX,
     DATE_START_UNIX,
     DATE_OF_INSERTION_UNIX 
 )
 SELECT
             r.[ORDER] AS [VACCINE_CAMPAIGN_ORDER],
             r.[CAMPAIGN_LABEL_NL] AS [VACCINE_CAMPAIGN_NAME_NL],
             r.[CAMPAIGN_LABEL_EN] AS [VACCINE_CAMPAIGN_NAME_EN],
             c.[CUMSUM_TOTAL_VACCINATED] AS [VACCINE_ADMINISTERED_TOTAL],
             c.[TOTAL_VACCINATED_7DAYS] AS [VACCINE_ADMINISTERED_LAST_WEEK],
             [dbo].[CONVERT_DATETIME_TO_UNIX]([dbo].[WEEK_START_ISO](c.[DATE_OF_STATISTICS])) AS [DATE_UNIX],
             [dbo].[CONVERT_DATETIME_TO_UNIX]([dbo].[WEEK_START_ISO](c.[DATE_OF_STATISTICS])) AS [DATE_END_UNIX],
             [dbo].[CONVERT_DATETIME_TO_UNIX](dateadd(day, -6,  [dbo].[WEEK_START_ISO](c.[DATE_OF_STATISTICS]))) AS [DATE_START_UNIX],
             [dbo].[CONVERT_DATETIME_TO_UNIX](c.[DATE_LAST_INSERTED]) AS [DATE_OF_INSERTION_UNIX]
 FROM CTE c
 INNER JOIN (
     SELECT
             [CAMPAIGN_CODE],
             [CAMPAIGN_LABEL_NL],
             [CAMPAIGN_LABEL_EN],
             [ORDER]
     FROM [VWSSTATIC].[RIVM_VACCINATION_CAMPAIGNS_MASTER_DATA] WITH(NOLOCK)
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTATIC].[RIVM_VACCINATION_CAMPAIGNS_MASTER_DATA] WITH(NOLOCK))
     ) r ON c.CAMPAIGN = r.[CAMPAIGN_CODE]
 WHERE c.[DATE_OF_STATISTICS] = (SELECT MAX([DATE_OF_STATISTICS]) FROM  CTE)
 END;