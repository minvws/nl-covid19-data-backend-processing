-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.
 
 -- 1) CREATE STORE PROCEDURE(S) INTER -> DEST.....
 CREATE   PROCEDURE [DBO].[SP_RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_VR_INTER_TO_DEST]
 AS
 BEGIN
     WITH CTE AS (
         SELECT 
             coverage.[DATE_LAST_INSERTED],
             coverage.[VERSION],
             coverage.[DATE_OF_REPORT],
             coverage.[DATE_OF_STATISTICS],
             coverage.[POPULATION],
             coverage.[REGION_CODE],
             coverage.[REGION_LEVEL],
             coverage.[REGION_NAME],
             age_groups.[AGE_GROUP],
             coverage.[VACCINATION_SERIE],
             coverage.[PERCENTAGE],
             coverage.[PERCENTAGE_LABEL]
         FROM [VWSINTER].[RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_VR] coverage
         INNER JOIN [VWSSTATIC].[COHORT_TO_AGE_GROUPS_MAPPING] age_groups 
             ON age_groups.[COHORT] = coverage.[BIRTH_YEAR]
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_VR])
     )
     INSERT INTO [VWSDEST].[RIVM_VACCINATIONS_BOOSTER_SHOTS_COVERAGE_VR] (
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
     )
     SELECT 
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
     FROM CTE
 END