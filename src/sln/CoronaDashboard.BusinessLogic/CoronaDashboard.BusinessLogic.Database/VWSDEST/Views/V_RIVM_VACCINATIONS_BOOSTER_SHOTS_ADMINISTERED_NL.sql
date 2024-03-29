﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN   VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.
 
 -- 1) CREATE VIEW(S).....
 CREATE   VIEW [VWSDEST].[V_RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL]
 AS
     WITH CTE AS (
         SELECT
             -- [GGD_ADMINISTERED_BOOSTER_SHOTS_7DAYS],
             [GGD_CUMSUM_ADMINISTERED_BOOSTER_SHOTS],
             [OTHERS_CUMSUM_ESTIMATED_BOOSTER_SHOTS],
             [GGD_CUMSUM_ADMINISTERED_BOOSTER_SHOTS] + [OTHERS_CUMSUM_ESTIMATED_BOOSTER_SHOTS] AS [CUMSUM_ADMINISTERED_BOOSTER_SHOTS],
             -- [DBO].[CONVERT_DATETIME_TO_UNIX](DATEADD(day, -7, [DATE_OF_REPORT])) AS [DATE_START_UNIX],
             -- [DBO].[CONVERT_DATETIME_TO_UNIX]([DATE_OF_STATISTICS]) AS [DATE_END_UNIX],
             [DBO].[CONVERT_DATETIME_TO_UNIX]([DATE_OF_STATISTICS]) AS [DATE_UNIX],
             [DBO].[CONVERT_DATETIME_TO_UNIX]([DATE_LAST_INSERTED]) AS [DATE_OF_INSERTION_UNIX]
         FROM [VWSDEST].[RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL]        
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL])
     ) 
     SELECT 
         -- [GGD_ADMINISTERED_BOOSTER_SHOTS_7DAYS] AS [GGD_ADMINISTERED_LAST_7_DAYS],
         [GGD_CUMSUM_ADMINISTERED_BOOSTER_SHOTS] AS [GGD_ADMINISTERED_TOTAL],
         [OTHERS_CUMSUM_ESTIMATED_BOOSTER_SHOTS] AS [OTHERS_ADMINISTERED_TOTAL],
         [CUMSUM_ADMINISTERED_BOOSTER_SHOTS] AS [ADMINISTERED_TOTAL],
         [DATE_OF_INSERTION_UNIX],
         -- [DATE_START_UNIX],
         -- [DATE_END_UNIX]
         [DATE_UNIX]
     FROM CTE
     -- WHERE [DATE_END_UNIX] = (SELECT MAX([DATE_END_UNIX]) FROM CTE);
     WHERE [DATE_UNIX] = (SELECT MAX([DATE_UNIX]) FROM CTE);