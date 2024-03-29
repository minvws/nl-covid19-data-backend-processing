﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE [dbo].[SP_GGD_TESTED_PEOPLE_BASE]
AS
BEGIN
    -- Filter the records and select columns
WITH BASE_CTE AS (
SELECT  
       [DATE_OF_STATISTICS]
      ,[SECURITY_REGION_CODE]
      ,[SECURITY_REGION_NAME]
      ,[TESTED_WITH_RESULT]
      ,[TESTED_POSITIVE]
      ,[DATE_LAST_INSERTED]
  FROM [VWSINTER].[GGD_TESTED_PEOPLE]
  WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[GGD_TESTED_PEOPLE])
  -- Make sure that last three days(including today) are filtered out
    AND DATEDIFF(DAY, DATE_OF_STATISTICS, DATE_OF_REPORT) > 1 
    AND SECURITY_REGION_CODE <> '' AND SECURITY_REGION_CODE <> 'NL00'

UNION ALL 

SELECT  
       [DATE_OF_STATISTICS]						AS [DATE_OF_STATISTICS]
      ,'NL00'									AS [SECURITY_REGION_CODE]
      ,'Netherlands'							AS [SECURITY_REGION_NAME]
      ,SUM([TESTED_WITH_RESULT])				AS [TESTED_WITH_RESULT]
      ,SUM([TESTED_POSITIVE])					AS [TESTED_POSITIVE]
      ,[DATE_LAST_INSERTED]						AS [DATE_LAST_INSERTED]
  FROM [VWSINTER].[GGD_TESTED_PEOPLE]
  WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[GGD_TESTED_PEOPLE])
  -- Make sure that last three days(including today) are filtered out
    AND DATEDIFF(DAY, DATE_OF_STATISTICS, DATE_OF_REPORT) > 1 
   group by   [DATE_OF_STATISTICS] ,[DATE_LAST_INSERTED]



)
--Determine Totals over date ranges
,TOTALS_CTE AS (
SELECT  
       [DATE_OF_STATISTICS]
      ,LAG ([DATE_OF_STATISTICS] ,6)                   OVER (PARTITION BY SECURITY_REGION_CODE ORDER BY [DATE_OF_STATISTICS] ASC)  as [DATE_RANGE_START]
      ,LAG ([DATE_OF_STATISTICS] ,1)                   OVER (PARTITION BY SECURITY_REGION_CODE ORDER BY [DATE_OF_STATISTICS] ASC)  as [DATE_OF_STATISTICS_LAG]
      ,LAG ([DATE_OF_STATISTICS] ,7)                   OVER (PARTITION BY SECURITY_REGION_CODE ORDER BY [DATE_OF_STATISTICS] ASC)  as [DATE_RANGE_START_LAG]
      ,[SECURITY_REGION_CODE]
      ,[SECURITY_REGION_NAME]
      ,[TESTED_WITH_RESULT] AS TESTS
      ,[TESTED_POSITIVE]    AS POSITIVE_TESTS
      ,ROUND(CAST([TESTED_POSITIVE]         AS FLOAT) *100     / NULLIF([TESTED_WITH_RESULT],0)    ,1) AS [PERCENTAGE_POSITIVE]
      
      --7day averages
      ,AVG(CAST([TESTED_WITH_RESULT]  AS FLOAT)) OVER (PARTITION BY SECURITY_REGION_CODE ORDER BY [DATE_OF_STATISTICS] ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as [7D_AVERAGE_TESTS]
      ,AVG(CAST([TESTED_POSITIVE]     AS FLOAT)) OVER (PARTITION BY SECURITY_REGION_CODE ORDER BY [DATE_OF_STATISTICS] ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as [7D_AVERAGE_POSITIVE_TESTS]
      ,AVG(CAST([TESTED_WITH_RESULT]  AS FLOAT)) OVER (PARTITION BY SECURITY_REGION_CODE ORDER BY [DATE_OF_STATISTICS] ASC ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) as [7D_AVERAGE_TESTS_LAG]
      ,AVG(CAST([TESTED_POSITIVE]     AS FLOAT)) OVER (PARTITION BY SECURITY_REGION_CODE ORDER BY [DATE_OF_STATISTICS] ASC ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) as [7D_AVERAGE_POSITIVE_TESTS_LAG]
FROM BASE_CTE
)
INSERT INTO VWSDEST.GGD_TESTED_PEOPLE_BASE
    (
       [DATE_OF_STATISTICS]
      ,[DATE_RANGE_START]
      ,DATE_OF_STATISTICS_LAG
      ,DATE_RANGE_START_LAG
      ,NEW_DATE_OF_REPORT_UNIX
      ,DATE_RANGE_START_UNIX
      ,OLD_DATE_OF_REPORT_UNIX
      ,[REGION_CODE]
      ,[REGION_NAME]
      ,TESTS
      ,POSITIVE_TESTS
      ,[PERCENTAGE_POSITIVE]
      ,[7D_AVERAGE_TESTS]
      ,[7D_AVERAGE_TESTS_LAG]
      ,[7D_AVERAGE_TESTS_DIFF]
      ,[7D_AVERAGE_POSITIVE_TESTS]
      ,[7D_AVERAGE_POSITIVE_TESTS_LAG]
      ,[7D_AVERAGE_POSITIVE_TESTS_DIFF]
      ,[7D_AVERAGE_PERCENTAGE_POSITIVE]
      ,[7D_AVERAGE_PERCENTAGE_POSITIVE_LAG]
      ,[7D_AVERAGE_PERCENTAGE_POSITIVE_DIFF]
    )
SELECT
       [DATE_OF_STATISTICS]
      ,[DATE_RANGE_START]
      ,DATE_OF_STATISTICS_LAG
      ,DATE_RANGE_START_LAG
      ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_STATISTICS])     AS  NEW_DATE_OF_REPORT_UNIX
      ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_RANGE_START])       AS  DATE_RANGE_START_UNIX
      ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_STATISTICS])     AS  OLD_DATE_OF_REPORT_UNIX
      ,[SECURITY_REGION_CODE]
      ,[SECURITY_REGION_NAME]
      ,TESTS
      ,POSITIVE_TESTS
      ,[PERCENTAGE_POSITIVE]
      
      --Tests total
      ,CASE WHEN
		[DATE_RANGE_START] IS NULL THEN NULL
		ELSE ROUND([7D_AVERAGE_TESTS],1)
	   END AS [7D_AVERAGE_TESTS]
      ,CASE WHEN
		[DATE_RANGE_START_LAG] IS NULL THEN NULL
		ELSE ROUND([7D_AVERAGE_TESTS_LAG],1)
	   END AS [7D_AVERAGE_TESTS_LAG]
      ,CASE WHEN
		[DATE_RANGE_START_LAG] IS NULL THEN NULL
		ELSE ROUND([7D_AVERAGE_TESTS] - [7D_AVERAGE_TESTS_LAG], 1) 
	   END AS [7D_AVERAGE_TESTS_DIFF]

      --Positive tests
      ,CASE WHEN
		[DATE_RANGE_START] IS NULL THEN NULL
		ELSE ROUND([7D_AVERAGE_POSITIVE_TESTS],1)
	   END AS [7D_AVERAGE_POSITIVE_TESTS]
	  ,CASE WHEN
		[DATE_RANGE_START_LAG] IS NULL THEN NULL
		ELSE ROUND([7D_AVERAGE_POSITIVE_TESTS_LAG],1)
	   END AS [7D_AVERAGE_POSITIVE_TESTS_LAG]
      ,CASE WHEN
		[DATE_RANGE_START_LAG] IS NULL THEN NULL
		ELSE ROUND([7D_AVERAGE_POSITIVE_TESTS] - [7D_AVERAGE_POSITIVE_TESTS_LAG]         ,1) 
	   END AS[7D_AVERAGE_POSITIVE_TESTS_DIFF]

      --Percentages
	  ,CASE WHEN
		[DATE_RANGE_START] IS NULL THEN NULL
		ELSE ROUND([7D_AVERAGE_POSITIVE_TESTS]*100     / NULLIF([7D_AVERAGE_TESTS],0)    ,1)
	   END AS [7D_AVERAGE_PERCENTAGE_POSITIVE]
      ,CASE WHEN
		[DATE_RANGE_START_LAG] IS NULL THEN NULL
		ELSE ROUND([7D_AVERAGE_POSITIVE_TESTS_LAG]*100 / NULLIF([7D_AVERAGE_TESTS_LAG],0),1)
	   END AS [7D_AVERAGE_PERCENTAGE_POSITIVE_LAG]
      ,CASE WHEN
		[DATE_RANGE_START_LAG] IS NULL THEN NULL
		ELSE ROUND((ROUND([7D_AVERAGE_POSITIVE_TESTS]*100     / NULLIF([7D_AVERAGE_TESTS],0),1) - ROUND([7D_AVERAGE_POSITIVE_TESTS_LAG]*100     / NULLIF([7D_AVERAGE_TESTS_LAG],0),1)), 1) 
	   END AS [7D_AVERAGE_PERCENTAGE_POSITIVE_DIFF]
FROM TOTALS_CTE

END;