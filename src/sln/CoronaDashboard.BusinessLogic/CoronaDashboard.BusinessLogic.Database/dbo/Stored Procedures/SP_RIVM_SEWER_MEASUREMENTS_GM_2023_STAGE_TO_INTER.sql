-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 -- 1) CREATE STORE PROCEDURE(S) STAGE -> INTER.....
 CREATE   PROCEDURE [DBO].[SP_RIVM_SEWER_MEASUREMENTS_GM_2023_STAGE_TO_INTER]
 AS
 BEGIN
     INSERT INTO [VWSINTER].[RIVM_SEWER_MEASUREMENTS_GM_2023] (
         [VERSION],
         [DATE_OF_REPORT],
         [YEAR],
         [WEEK],
         [START_DATE],
         [END_DATE],
         [REGION_CODE],
         [REGION_NAME],
         [RNA_FLOW_PER_100000_WEEKLYMEAN]
     )
     SELECT
         -- Provided datetime format in source file is yyyy-mm-dd
         [VERSION],
         CONVERT(DATETIME, [DATE_OF_REPORT], 102),
         [YEAR],
         [WEEK],
         CONVERT(DATETIME, [START_DATE], 102),
         CONVERT(DATETIME, [END_DATE], 102),
         [REGION_CODE],
         [REGION_NAME],
         IIF([RNA_FLOW_PER_100000_WEEKLYMEAN] IN ('', 'NA'), NULL, [RNA_FLOW_PER_100000_WEEKLYMEAN])
     FROM 
         [VWSSTAGE].[RIVM_SEWER_MEASUREMENTS_GM_2023]
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].[RIVM_SEWER_MEASUREMENTS_GM_2023])
 END;