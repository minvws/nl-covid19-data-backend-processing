﻿-- 1) CREATE STORE PROCEDURE(S).....
 CREATE     PROCEDURE [DBO].[SP_POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY]
 AS
 BEGIN
     -- MOVE POSITIVELY TESTED PERSONS DATA FROM INTERMEDIATE TABLE TO DESTINATION TABLE. 
     -- MAIN SELECT AND INSERT STATEMENT FOR PEOPLE TESTED POSITIVELY. CALCULATION PER DATE OF REPORT.
     WITH AGEGROUP_POPULATION_DATERANGE AS (
         SELECT 
             [GM_CODE]
             ,[DATUM_PEILING] AS [DATE_FROM]
             -- 2100-01-01 IS USED AS CONVENTION FOR THE MOST RECENT VERSIONS AS NO END DATE IS KNOWN YET.
             ,ISNULL(LEAD([DATUM_PEILING],1) OVER (PARTITION BY [GM_CODE] ORDER BY [DATUM_PEILING] ASC),CAST('2100-01-01' AS DATE)) AS [DATE_TO]
             ,CAST([POPULATIE] AS FLOAT) AS [POPULATION] --ENABLE PROPER DIVISION
         FROM [VWSSTATIC].[CBS_POPULATION_GM]
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTATIC].[CBS_POPULATION_GM]) -- DETERMINE RANGES IN WHICH POPULATION NUMBERS SHOULD BE USED
     ) 
     ,
     BASE_CTE AS (
             SELECT
                 [DATE_OF_PUBLICATION] AS [DATE_OF_REPORT],
                 [DBO].[CONVERT_DATETIME_TO_UNIX]([DATE_OF_PUBLICATION]) AS [DATE_OF_REPORT_UNIX],
                 [TOTAL_REPORTED] AS [INCREASE_ABSOLUTE],
                 [MUNICIPALITY_CODE],
                 [MUNICIPALITY_NAME],
                 T1.[POPULATION]
             FROM
                 [VWSINTER].[RIVM_COVID_19_NUMBER_MUNICIPALITY] T0
             LEFT JOIN AGEGROUP_POPULATION_DATERANGE T1
                 ON T0.[MUNICIPALITY_CODE] = T1.[GM_CODE]
                 AND (T0.[DATE_OF_PUBLICATION] >= T1.[DATE_FROM] AND T0.[DATE_OF_PUBLICATION] < T1.[DATE_TO])
             WHERE T0.[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[RIVM_COVID_19_NUMBER_MUNICIPALITY])
                 AND [DATE_OF_PUBLICATION] > '1900-01-01 00:00:00.000'
                 AND [MUNICIPALITY_CODE] != ''
     ), 
     TOTALS_CTE AS (
         SELECT 
             [DATE_OF_REPORT]
             ,[DATE_OF_REPORT_UNIX]
             ,[MUNICIPALITY_CODE]
             ,[MUNICIPALITY_NAME]
             ,SUM(CAST([INCREASE_ABSOLUTE] AS FLOAT)) AS [INCREASE_ABSOLUTE]
             --CALCULATE THE INFECTED INHABITANTS IN THE REGION PER 100K
             ,SUM(CAST([INCREASE_ABSOLUTE] AS FLOAT))/[DBO].[NORMALIZATION](CAST([POPULATION] AS FLOAT)) AS [INCREASE]    
             ,LAG([DATE_OF_REPORT] ,6) OVER (PARTITION BY [MUNICIPALITY_CODE] ORDER BY [DATE_OF_REPORT] ASC) AS [DATE_RANGE_START]
             ,LAG(DATE_OF_REPORT ,1) OVER (PARTITION BY [MUNICIPALITY_CODE] ORDER BY [DATE_OF_REPORT] ASC) AS [DATE_OF_REPORTS_LAG]
             ,LAG(DATE_OF_REPORT ,7) OVER (PARTITION BY [MUNICIPALITY_CODE] ORDER BY [DATE_OF_REPORT] ASC) AS [DATE_RANGE_START_LAG]
             ,[POPULATION]
             ,LAG([POPULATION] ,6) OVER (PARTITION BY [MUNICIPALITY_CODE] ORDER BY [DATE_OF_REPORT] ASC) AS [POPULATION_RANGE_START]
             ,LAG([POPULATION] ,7) OVER (PARTITION BY [MUNICIPALITY_CODE] ORDER BY [DATE_OF_REPORT] ASC) AS [POPULATION_RANGE_START_LAG]
         FROM BASE_CTE T1
         GROUP BY [DATE_OF_REPORT_UNIX], [DATE_OF_REPORT], [MUNICIPALITY_CODE], [MUNICIPALITY_NAME] , [POPULATION]
         -- ORDER BY MUNICIPALITY_CODE, DATE_OF_REPORT
     ),
     CALCULATED_CTE AS (    
             SELECT
                 [DATE_OF_REPORT],
                 [DATE_OF_REPORT_UNIX],
                 [MUNICIPALITY_CODE],
                 [MUNICIPALITY_NAME],
                 [INCREASE_ABSOLUTE] AS [INFECTED_DAILY_TOTAL],
                 [INCREASE] AS [INFECTED_DAILY_INCREASE],
                 [DATE_RANGE_START],
                 [DATE_OF_REPORTS_LAG],
                 [DATE_RANGE_START_LAG],
                 --ADDITIONAL DATA
                 [POPULATION_RANGE_START],
                 [POPULATION_RANGE_START_LAG],
                 --CALCULATED MOVING AVERAGES
                 --AVERAGE OF RELATIVE NUMBERS 
                 ROUND(AVG(CAST([INCREASE_ABSOLUTE] AS FLOAT)) OVER (
                         PARTITION BY [MUNICIPALITY_CODE] 
                         ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 0)
                 / ([POPULATION_RANGE_START]/100000) AS [7D_AVERAGE_INFECTED_DAILY_INCREASE],
                 AVG(CAST([INCREASE_ABSOLUTE] AS FLOAT)) OVER (
                         PARTITION BY [MUNICIPALITY_CODE] 
                         ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING)
                 / ([POPULATION_RANGE_START_LAG]/100000)  AS [7D_AVERAGE_INFECTED_DAILY_INCREASE_LAG],
                 --AVERAGE OF TOTAL INFECTIONS(ABSOLUTE). USED TO CALCULATE DIFFERENCE
                 AVG(CAST([INCREASE_ABSOLUTE] AS FLOAT)) OVER (
                         PARTITION BY [MUNICIPALITY_CODE] 
                         ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
                     AS [7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE]
             FROM TOTALS_CTE
     )
     INSERT INTO [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY] (
         [DATE_OF_REPORT],
         [DATE_OF_REPORT_UNIX],
         [MUNICIPALITY_CODE],
         [MUNICIPALITY_NAME],
         [INFECTED_DAILY_TOTAL],
         [INFECTED_DAILY_INCREASE],
         [DATE_RANGE_START],
         [DATE_OF_REPORTS_LAG],
         [DATE_RANGE_START_LAG],
         [7D_AVERAGE_INFECTED_DAILY_INCREASE_TOTAL],
         [7D_AVERAGE_INFECTED_DAILY_INCREASE_LAG],
         [7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE]
     )
     SELECT 
         [DATE_OF_REPORT],
         [DATE_OF_REPORT_UNIX],
         [MUNICIPALITY_CODE],
         [MUNICIPALITY_NAME],
         [INFECTED_DAILY_TOTAL],
         [INFECTED_DAILY_INCREASE],
         [DATE_RANGE_START],
         [DATE_OF_REPORTS_LAG],
         [DATE_RANGE_START_LAG],
         --DO TWEAKS TO 7DAY AVERAGE: ROUNDING AND NULLS S
         CASE 
             WHEN [DATE_OF_REPORT] < DATEADD(DAY, 6,'2020-03-02') THEN NULL
             ELSE ROUND([7D_AVERAGE_INFECTED_DAILY_INCREASE],1)
         END AS [7D_AVERAGE_INFECTED_DAILY_INCREASE],
         CASE 
             WHEN [DATE_OF_REPORT] < DATEADD(DAY, 7,'2020-03-02') THEN NULL
             ELSE ROUND([7D_AVERAGE_INFECTED_DAILY_INCREASE_LAG],1) 
         END AS [7D_AVERAGE_INFECTED_DAILY_INCREASE_LAG],
         CASE 
             WHEN [DATE_OF_REPORT] < DATEADD(DAY, 6,'2020-03-02') THEN NULL
             ELSE ROUND([7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE],1)
         END AS [7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE]
     FROM CALCULATED_CTE
 END;