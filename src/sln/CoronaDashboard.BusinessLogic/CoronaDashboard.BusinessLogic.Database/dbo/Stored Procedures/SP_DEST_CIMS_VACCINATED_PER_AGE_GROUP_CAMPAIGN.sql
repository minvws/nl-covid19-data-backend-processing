﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN   VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.
 
 CREATE    PROCEDURE [DBO].[SP_DEST_CIMS_VACCINATED_PER_AGE_GROUP_CAMPAIGN]
 AS
 BEGIN
 -- APPLY FILTERS ON MAIN INPUT TABLE AND PERFORM TRANSFORMATIONS
 WITH LAST_CTE AS (
     SELECT
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS_WEEK_START],
         [DATE_OF_STATISTICS_WEEK_END],
         [BIRTH_COHORT],
         [AGE_GROUP],
         [POPULATION_AGE_GROUP],
         [VACCINATION_CAMPAIGN],
         [RECEIVED],
         [COVERAGE]
     FROM [VWSINTER].[CIMS_VACCINATED_PER_AGE_GROUP_CAMPAIGN]
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[CIMS_VACCINATED_PER_AGE_GROUP_CAMPAIGN])
         AND LOWER([BIRTH_COHORT]) != 'unknown'
 )
 INSERT INTO [VWSDEST].[CIMS_VACCINATED_PER_AGE_GROUP_CAMPAIGN](
     [DATE_OF_REPORT],
     [DATE_OF_STATISTICS_WEEK_START],
     [DATE_OF_STATISTICS_WEEK_END],
     [AGE_GROUP],
     [VACCINATION_CAMPAIGN],
     [RECEIVED],
     [COVERAGE]
 )
 SELECT
     T.[DATE_OF_REPORT],
     T.[DATE_OF_STATISTICS_WEEK_START],
     T.[DATE_OF_STATISTICS_WEEK_END],
     T.[AGE_GROUP],
     T.[VACCINATION_CAMPAIGN],
     T.[RECEIVED],
     T.[COVERAGE]
     FROM LAST_CTE AS T
     --TAKE ONLY THE LAST VALUE
     WHERE T.[DATE_OF_STATISTICS_WEEK_START] = (SELECT MAX([DATE_OF_STATISTICS_WEEK_START]) FROM LAST_CTE)
 END