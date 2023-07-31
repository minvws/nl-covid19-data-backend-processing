﻿-- Hiervoor eenmalig een query runnen die dit INTO een VWSARCHIVE tabel schrijft
 -- met als extensie 20220908 en die filtert op de datum 2022-0908
 
 
 -- 1) CREATE STORED PROCEDURE(S): ARCHIVE EXISTING DATA
 CREATE   PROCEDURE [DBO].[SP_RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_GM_DEST_TO_ARCHIVED_20220908]
 AS
 BEGIN
     TRUNCATE TABLE [VWSARCHIVE].[RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_GM_ARCHIVED_20220908]
 
     INSERT INTO [VWSARCHIVE].[RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_GM_ARCHIVED_20220908] (
         [DATE_LAST_INSERTED],
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS],
         [POPULATION],
         [REGION_CODE],
         [REGION_LEVEL],
         [REGION_NAME],
         [AGE_GROUP],
         [VACCINATION_TYPE],
         [PERCENTAGE],
         [PERCENTAGE_LABEL]
     )
     SELECT
         [DATE_LAST_INSERTED],
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS],
         [POPULATION],
         [REGION_CODE],
         [REGION_LEVEL],
         [REGION_NAME],
         [AGE_GROUP],
         [VACCINATION_SERIE],
         [PERCENTAGE],
         [PERCENTAGE_LABEL] 
     FROM [VWSDEST].[RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_GM] WITH(NOLOCK)
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_GM])
 END;