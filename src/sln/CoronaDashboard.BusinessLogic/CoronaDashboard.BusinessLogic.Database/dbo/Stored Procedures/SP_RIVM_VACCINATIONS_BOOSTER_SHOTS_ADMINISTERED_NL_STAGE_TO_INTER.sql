﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.
 
 -- 1) CREATE STORE PROCEDURE(S) STAGE -> INTER.....
 CREATE   PROCEDURE [DBO].[SP_RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL_STAGE_TO_INTER]
 AS
 BEGIN
     INSERT INTO [VWSINTER].[RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL]
     (
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS],
         [BOOSTER_SHOT_TYPE],
         [ADMINISTERED_BOOSTER_SHOTS]
     )
     SELECT
         CAST([VERSION] AS INT) AS [VERSION],
 		[DBO].[TRY_CONVERT_TO_DATETIME]([DATE_OF_REPORT])  AS [DATE_OF_REPORT],
 		[DBO].[TRY_CONVERT_TO_DATETIME]([DATE_OF_STATISTICS]) AS [DATE_OF_STATISTICS],
         UPPER(TRIM([BOOSTER_SHOT_TYPE])) AS [BOOSTER_SHOT_TYPE],
         CAST([ADMINISTERED_BOOSTER_SHOTS] AS INT) AS [ADMINISTERED_BOOSTER_SHOTS]
     FROM 
         [VWSSTAGE].[RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL]
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].[RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL]);
 END;