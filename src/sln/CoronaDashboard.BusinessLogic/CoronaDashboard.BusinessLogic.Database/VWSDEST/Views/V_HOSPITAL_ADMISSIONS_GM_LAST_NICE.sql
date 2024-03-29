﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 -- JSON-KEY: hospital_nice PER GM_COLLECTION
 
 CREATE   VIEW [VWSDEST].[V_HOSPITAL_ADMISSIONS_GM_LAST_NICE] AS
 SELECT
     DATE_UNIX,
     GMCODE,
     ADMISSIONS_ON_DATE_OF_ADMISSION,
     ADMISSIONS_ON_DATE_OF_REPORTING,
     ADMISSIONS_ON_DATE_OF_ADMISSION_PER_100000,
     DATE_OF_INSERTION_UNIX
 
 FROM(
 SELECT
     [dbo].[CONVERT_DATETIME_TO_UNIX]([DATE_OF_STATISTICS]) AS [DATE_UNIX],
     [GM_CODE] AS [GMCODE],
     [DBO].[NO_NEGATIVE_NUMBER_F](HOSPITALIZED) AS [ADMISSIONS_ON_DATE_OF_ADMISSION],
     [DBO].[NO_NEGATIVE_NUMBER_F](REPORTED) AS [ADMISSIONS_ON_DATE_OF_REPORTING],
     CAST([HOSPITALIZED_PER_100000] AS NUMERIC(10,1)) AS [ADMISSIONS_ON_DATE_OF_ADMISSION_PER_100000],
     [dbo].[CONVERT_DATETIME_TO_UNIX](DATE_LAST_INSERTED) AS [DATE_OF_INSERTION_UNIX],
     RANK() OVER (PARTITION BY [GM_CODE] ORDER BY [DATE_OF_STATISTICS] DESC) AS [RANKING]
 FROM [VWSDEST].[NICE_HOSPITAL_GM] WITH(NOLOCK)
 WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[NICE_HOSPITAL_GM] WITH(NOLOCK))
 AND [WEEK_START] <> [WEEK_START_LAG]) AS T1
 WHERE T1.[RANKING] =1
 AND [GMCODE] !=''