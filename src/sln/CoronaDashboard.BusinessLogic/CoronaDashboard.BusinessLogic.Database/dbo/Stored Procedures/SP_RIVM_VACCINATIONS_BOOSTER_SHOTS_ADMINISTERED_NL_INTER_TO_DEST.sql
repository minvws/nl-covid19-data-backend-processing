﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.
     
 -- 1) CREATE STORE PROCEDURE(S) INTER -> DEST.....
 CREATE   PROCEDURE [dbo].[SP_RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL_INTER_TO_DEST]
 AS
 BEGIN
     WITH CTE AS (
         SELECT 
             [VERSION],
             [DATE_OF_REPORT],
 			[DATE_OF_STATISTICS],
             [BOOSTER_SHOT_TYPE],
             [ADMINISTERED_BOOSTER_SHOTS]
         FROM [VWSINTER].[RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL]
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL])
     )
     INSERT INTO [VWSDEST].[RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL] (
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS],
         [GGD_ADMINISTERED_BOOSTER_SHOTS],
         [GGD_CUMSUM_ADMINISTERED_BOOSTER_SHOTS],
         [GGD_ADMINISTERED_BOOSTER_SHOTS_7DAYS],
         [OTHERS_ESTIMATED_BOOSTER_SHOTS],
         [OTHERS_CUMSUM_ESTIMATED_BOOSTER_SHOTS],
         [OTHERS_ESTIMATED_BOOSTER_SHOTS_7DAYS]
     )
     SELECT 	    
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS],
         [GEZETTE_BOOSTER1_GGD] AS [GGD_ADMINISTERED_BOOSTER_SHOTS],
         SUM([GEZETTE_BOOSTER1_GGD]) OVER (ORDER BY [DATE_OF_STATISTICS]) AS [GGD_CUMSUM_ADMINISTERED_BOOSTER_SHOTS],
         SUM([GEZETTE_BOOSTER1_GGD]) OVER (ORDER BY [DATE_OF_STATISTICS] ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS [GGD_ADMINISTERED_BOOSTER_SHOTS_7DAYS],
         [GEZETTE_BOOSTER1_OVERIG] AS [OTHERS_ESTIMATED_BOOSTER_SHOTS],
         SUM([GEZETTE_BOOSTER1_OVERIG]) OVER (ORDER BY [DATE_OF_STATISTICS]) AS [OTHERS_CUMSUM_ESTIMATED_BOOSTER_SHOTS],
         SUM([GEZETTE_BOOSTER1_OVERIG]) OVER (ORDER BY [DATE_OF_STATISTICS] ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS [OTHERS_ESTIMATED_BOOSTER_SHOTS_7DAYS]
     FROM CTE
     PIVOT (
         SUM([ADMINISTERED_BOOSTER_SHOTS])
         FOR [BOOSTER_SHOT_TYPE]
         IN (
             [GEZETTE_BOOSTER1_GGD],
             [GEZETTE_BOOSTER1_OVERIG]
         )
     ) AS PIVOTTABLE
 END;