﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.
 
 -- 1) CREATE STORE PROCEDURE(S) STAGE -> INTER.....
 --TODO pick allready the boostershot_type1 column allready by VR
 CREATE   PROCEDURE [DBO].[SP_CIMS_VACCINATED_PER_AGE_GROUP_CAMPAIGN_GM_VR_STAGE_TO_INTER]
 AS
 BEGIN
     INSERT INTO [VWSINTER].[CIMS_VACCINATED_PER_AGE_GROUP_CAMPAIGN_GM_VR] (
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS],
 	    [POPULATION],
 	    [REGION_CODE] ,
         [REGION_LEVEL],
         [REGION_NAME] ,
         [AGE_GROUP],
         [BIRTH_YEAR],
         [VACCINATION_CAMPAIGN],
         [PERCENTAGE_SOURCE],
         [PERCENTAGE],
         [PERCENTAGE_LABEL]
 
     )
     SELECT
         CAST([VERSION] AS INT),
         [DBO].[TRY_CONVERT_TO_DATETIME]([DATE_OF_REPORT]),
         [DBO].[TRY_CONVERT_TO_DATETIME]([DATE_OF_STATISTICS]),
         CAST([POPULATION] AS BIGINT),
         [REGION_CODE],
         [REGION_LEVEL],
         [REGION_NAME],
         [AGE_GROUP],
         [BIRTH_YEAR],
         [VACCINATION_CAMPAIGN],
         [PERCENTAGE] AS [PERCENTAGE_SOURCE],
         CASE
             WHEN [PERCENTAGE] IN ('<=5', '>=95', '9999', '9999.9') THEN NULL
             ELSE ISNULL(NULLIF([PERCENTAGE], ''), 0)
             END AS [PERCENTAGE],
         CASE
             WHEN [PERCENTAGE] = '<=5' THEN [PERCENTAGE]
             WHEN [PERCENTAGE] = '>=95' THEN [PERCENTAGE]
             ELSE NULL
             END AS [PERCENTAGE_LABEL]
     FROM 
         [VWSSTAGE].[CIMS_VACCINATED_PER_AGE_GROUP_CAMPAIGN_GM_VR]
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].[CIMS_VACCINATED_PER_AGE_GROUP_CAMPAIGN_GM_VR])
 END;