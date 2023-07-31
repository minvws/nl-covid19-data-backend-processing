-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   PROCEDURE [dbo].[SP_ECDC_CASES_INTER]
 AS
 BEGIN
     INSERT INTO VWSINTER.ECDC_CASES
     (
         [COUNTRY],
         [COUNTRY_CODE],
         [CONTINENT],
         [POPULATION],
         [INDICATOR],
         [WEEKLY_COUNT],
         [YEAR_WEEK],
         [WEEK_START],
         [WEEK_END],
         [RATE_14_DAY],
         [CUMULATIVE_COUNT],
         [SOURCE]
     )
      SELECT
         [COUNTRY],
         [COUNTRY_CODE],
         [CONTINENT],
         CAST([POPULATION] AS BIGINT) AS [POPULATION],
         [INDICATOR],
         CASE 
             WHEN [WEEKLY_COUNT] = 'NA'
             THEN CAST('' AS FLOAT)
             ELSE CAST([WEEKLY_COUNT] AS BIGINT) 
         END AS [WEEKLY_COUNT],  
         [YEAR_WEEK],
         CAST([dbo].[CONVERT_ISO_WEEK_TO_DATETIME](LEFT(YEAR_WEEK,4),RIGHT(YEAR_WEEK,2)) AS DATE) AS [WEEK_START],
         CAST([dbo].[WEEK_END]([dbo].[CONVERT_ISO_WEEK_TO_DATETIME](LEFT(YEAR_WEEK,4),RIGHT(YEAR_WEEK,2))) AS DATE ) AS [WEEK_END],
         CASE 
             WHEN [RATE_14_DAY] = 'NA'
             THEN CAST('' AS FLOAT)
             ELSE CAST([RATE_14_DAY] AS FLOAT) 
         END AS [RATE_14_DAY],       
         CASE 
             WHEN [CUMULATIVE_COUNT] = 'NA'
             THEN NULL
             ELSE CAST([CUMULATIVE_COUNT] AS BIGINT) 
         END AS [CUMULATIVE_COUNT],
         [SOURCE]
     FROM 
        VWSSTAGE.ECDC_CASES
     WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.ECDC_CASES)
 END;