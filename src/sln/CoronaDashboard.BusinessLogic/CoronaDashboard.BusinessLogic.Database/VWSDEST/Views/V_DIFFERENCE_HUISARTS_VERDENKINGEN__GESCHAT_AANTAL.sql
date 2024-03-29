﻿CREATE    VIEW [VWSDEST].[V_DIFFERENCE_HUISARTS_VERDENKINGEN__GESCHAT_AANTAL] AS

WITH LAST_DATE_OF_REPORT AS (
	SELECT
		MAX(WEEK_UNIX) AS [LAST_DATE_OF_REPORT]
	FROM VWSDEST.SUSPICIONS_GENERAL_PRACTITIONERS
	--WHERE DATE_OF_REPORT >=  '2020-03-16 00:00:00.000'
		WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.SUSPICIONS_GENERAL_PRACTITIONERS)
),

BASE_CTE AS (
SELECT 
	WEEK_UNIX,
	LAG([WEEK_UNIX], 1, NULL) OVER (ORDER BY [DATE_LAST_INSERTED], [WEEK_UNIX]) AS [OLD_DATE_OF_REPORT_UNIX],
	LAG(GESCHAT_AANTAL, 1, NULL) OVER (ORDER BY [DATE_LAST_INSERTED], [WEEK_UNIX]) AS [OLD_VALUE],
	GESCHAT_AANTAL -
		LAG(GESCHAT_AANTAL, 1, NULL) OVER (ORDER BY [DATE_LAST_INSERTED], [WEEK_UNIX]) AS [DIFFERENCE]
--  dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.SUSPICIONS_GENERAL_PRACTITIONERS
--WHERE DATE_OF_REPORT >=  '2020-03-02 00:00:00.000'
WHERE DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) 
                            FROM VWSDEST.SUSPICIONS_GENERAL_PRACTITIONERS)

)

SELECT WEEK_UNIX AS NEW_DATE_UNIX
	  ,OLD_DATE_OF_REPORT_UNIX AS OLD_DATE_UNIX
	  ,CASE WHEN OLD_VALUE IS NULL THEN 0 ELSE OLD_VALUE END AS OLD_VALUE
	  ,CASE WHEN [DIFFERENCE] IS NULL THEN 0 ELSE [DIFFERENCE] END AS [DIFFERENCE]
FROM BASE_CTE T1
WHERE WEEK_UNIX = (SELECT LAST_DATE_OF_REPORT FROM LAST_DATE_OF_REPORT)