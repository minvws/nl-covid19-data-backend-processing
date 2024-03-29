﻿-- 1) CREATE STORED PROCEDURE(S).....
 CREATE   PROCEDURE [DBO].[SP_G_Number_NL]
 AS
 BEGIN
     -- CALCULATE POSITIVE 7 DAILY SUM
     WITH CTE AS (
         SELECT 
             [DATE_OF_REPORT]
             ,[DATE_OF_REPORT_UNIX]
             ,DATEADD(DAY, -6, DATE_OF_REPORT) AS [DATE_OF_REPORT_START]
             ,CASE WHEN COUNT([INFECTED_DAILY_TOTAL]) OVER (ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) = 7
                 THEN SUM(CAST([INFECTED_DAILY_TOTAL] AS FLOAT)) OVER (ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
                 ELSE NULL
             END AS [POSITIVE_DAILY_7D_SUM]
         FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE]
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE])
     )
     -- CALCULATE PERCENTUAL CHANGE BETWEEN WITH PREVIOUS 7D SUM
     INSERT INTO [VWSDEST].[G_NUMBER_NL] (
         [DATE_OF_REPORT]
         ,[DATE_OF_REPORT_UNIX]
         ,[DATE_OF_REPORT_START]
         ,[POSITIVE_DAILY_7D_SUM]
         ,[G_NUMBER]
     )
     SELECT 
         [DATE_OF_REPORT]
         ,[DATE_OF_REPORT_UNIX]
         ,[DATE_OF_REPORT_START]
         ,[POSITIVE_DAILY_7D_SUM]
         ,[DBO].[CALC_PERC_CHANGE] (
             [POSITIVE_DAILY_7D_SUM], 
             LAG([POSITIVE_DAILY_7D_SUM], 7, NULL) OVER (ORDER BY [DATE_OF_REPORT])
         ) * 100 AS [G_NUMBER]
     FROM CTE
 END;