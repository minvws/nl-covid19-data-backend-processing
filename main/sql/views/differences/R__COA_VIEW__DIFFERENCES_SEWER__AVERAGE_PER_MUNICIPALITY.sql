-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
/****** Object:  View [VWSDEST].[V_DIFFERENCE_SEWER__AVERAGE_PER_MUNICIPALITY]    Script Date: 12-11-2020 15:01:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE OR ALTER VIEW [VWSDEST].[V_DIFFERENCE_SEWER__AVERAGE_PER_MUNICIPALITY] AS

WITH PREPARATION AS (
	SELECT 
        WEEK_UNIX
    ,   dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_START(dbo.CONVERT_UNIX_TO_DATETIME(WEEK_UNIX))) AS WEEK_START_UNIX
    ,   dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_END(dbo.CONVERT_UNIX_TO_DATETIME(WEEK_UNIX))) AS WEEK_END_UNIX
    ,   GMCODE
    ,   AVERAGE_RNA_FLOW_PER_100000 AS AVERAGE
    ,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
	FROM VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY 
	WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
	                            FROM VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY)
	-- week_unix is on monday. We can only publish the data of that week after tuesday of next week.
	AND GETDATE() > dateadd(day, 8,dateadd(S, WEEK_UNIX, '1970-01-01'))
	AND dateadd(S, WEEK_UNIX, '1970-01-01') > '2020-01-01'
),

LAST_DATE_OF_REPORT AS (
	SELECT
		GMCODE,
		MAX(WEEK_UNIX) AS [LAST_DATE_OF_REPORT]
	FROM PREPARATION
	GROUP BY GMCODE
),


BASE_CTE AS (
SELECT 
    WEEK_UNIX,
	GMCODE,
	LAG([WEEK_UNIX], 1, NULL) OVER (PARTITION BY [GMCODE] ORDER BY [WEEK_UNIX]) AS [OLD_DATE_OF_REPORT_UNIX],
	LAG([AVERAGE], 1, NULL) OVER (PARTITION BY [GMCODE] ORDER BY [WEEK_UNIX]) AS [OLD_VALUE],
	[AVERAGE] -
		LAG([AVERAGE], 1, NULL) OVER (PARTITION BY [GMCODE] ORDER BY [WEEK_UNIX]) AS [DIFFERENCE]
--  dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM PREPARATION

)

SELECT WEEK_UNIX AS [NEW_DATE_UNIX]
	  ,T1.GMCODE
	  ,OLD_DATE_OF_REPORT_UNIX AS OLD_DATE_UNIX
	  ,CASE WHEN OLD_VALUE IS NULL THEN 0 ELSE OLD_VALUE END AS OLD_VALUE
	  ,CASE WHEN [DIFFERENCE] IS NULL THEN 0 ELSE [DIFFERENCE] END AS [DIFFERENCE]
FROM BASE_CTE T1
LEFT JOIN LAST_DATE_OF_REPORT T2
	ON T1.[GMCODE] = T2.[GMCODE]
WHERE WEEK_UNIX = LAST_DATE_OF_REPORT
;
GO


