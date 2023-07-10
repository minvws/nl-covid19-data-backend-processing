﻿-- 1) CREATE VIEW(S).....
 CREATE   VIEW [VWSDEST].[V_CIMS_VACCINATED_PER_AGE_GROUP_VR_ARCHIVE] 
 AS
     WITH CTE AS (
         SELECT
             dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_REPORT)                     AS DATE_OF_REPORT_UNIX,
             dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_STATISTICS)                 AS DATE_UNIX,
             [REGION_CODE]                                                    AS VRCODE,
             AGE_GROUP                                                        AS AGE_GROUP_RANGE,
             [BIRTH_YEAR]                                                     AS BIRTHYEAR_RANGE,
             CAST(ROUND(VACCINATION_COVERAGE_ALL, 0) AS INT)                  AS HAS_ONE_SHOT_PERCENTAGE,
             VACCINATION_COVERAGE_ALL_LABEL                                   AS HAS_ONE_SHOT_PERCENTAGE_LABEL,
             CAST(ROUND(VACCINATION_COVERAGE_COMPLETED, 0) AS INT)            AS FULLY_VACCINATED_PERCENTAGE,
             VACCINATION_COVERAGE_COMPLETED_LABEL                             AS FULLY_VACCINATED_PERCENTAGE_LABEL,
             dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)                 AS DATE_OF_INSERTION_UNIX
         FROM VWSARCHIVE.CIMS_VACCINATED_PER_AGE_GROUP_GM_VR WITH(NOLOCK)
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM VWSARCHIVE.CIMS_VACCINATED_PER_AGE_GROUP_GM_VR WITH(NOLOCK))
             AND LEFT(REGION_CODE,2) = 'VR'
     )
     SELECT 
         [DATE_OF_REPORT_UNIX],
         T1.[DATE_UNIX],
         T1.[VRCODE],
         [AGE_GROUP_RANGE],
         [BIRTHYEAR_RANGE],
         [HAS_ONE_SHOT_PERCENTAGE],
         [HAS_ONE_SHOT_PERCENTAGE_LABEL],
         [FULLY_VACCINATED_PERCENTAGE],
         [FULLY_VACCINATED_PERCENTAGE_LABEL],
         T1.[DATE_OF_INSERTION_UNIX]
     FROM CTE T1
     WHERE [AGE_GROUP_RANGE] NOT IN ('12-17')