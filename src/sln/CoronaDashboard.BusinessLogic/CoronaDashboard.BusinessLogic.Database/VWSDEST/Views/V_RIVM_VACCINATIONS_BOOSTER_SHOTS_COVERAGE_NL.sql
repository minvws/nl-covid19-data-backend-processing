﻿-- -- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN   VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.
 
 --1) CREATE VIEW(S).....
 CREATE   VIEW [VWSDEST].[V_RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_NL]
 AS
     WITH CTE AS (
         SELECT
             [AGE_GROUP],
             [COVERAGE_AGEGROUP],
             UPPER(DATENAME(dw, [DATE_OF_STATISTICS])) AS [DAY_OF_WEEK],
             [DBO].[CONVERT_DATETIME_TO_UNIX]([DATE_OF_STATISTICS]) AS [DATE_UNIX],            
             [DBO].[CONVERT_DATETIME_TO_UNIX]([DATE_LAST_INSERTED]) AS [DATE_LAST_INSERTED_UNIX]
         FROM [VWSDEST].[RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_NL] WITH(NOLOCK)
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_NL] WITH(NOLOCK))
             AND [AGE_GROUP] IN ('18+', '12+')
     )
     SELECT 
         [AGE_GROUP],
         CAST(CAST(COVERAGE_AGEGROUP AS FLOAT) AS [NUMERIC](10,1)) as [PERCENTAGE],
         [DATE_LAST_INSERTED_UNIX] as [DATE_OF_INSERTION_UNIX],
         [DATE_UNIX]
     FROM CTE
         WHERE [DATE_UNIX] = (SELECT MAX([DATE_UNIX]) FROM CTE WHERE [DAY_OF_WEEK] = 'SUNDAY')