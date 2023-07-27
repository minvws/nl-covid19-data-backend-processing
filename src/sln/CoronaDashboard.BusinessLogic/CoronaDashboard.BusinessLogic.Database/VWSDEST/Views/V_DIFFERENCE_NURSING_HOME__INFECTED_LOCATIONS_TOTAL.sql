﻿CREATE   VIEW [VWSDEST].[V_DIFFERENCE_NURSING_HOME__INFECTED_LOCATIONS_TOTAL] AS

WITH LAST_DATE_OF_REPORT AS (
	SELECT
		CAST(MAX(DATE_OF_REPORT) as datetime) AS [LAST_DATE_OF_REPORT]
	FROM VWSDEST.NURSING_HOMES_TOTALS
	WHERE DATE_OF_REPORT >=  '2020-03-16 00:00:00.000'
		AND DATE_OF_REPORT <  (SELECT MAX(DATE_OF_REPORT) FROM VWSDEST.NURSING_HOMES_TOTALS)
		AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.NURSING_HOMES_TOTALS)
),

BASE_CTE AS (
SELECT 
	DATE_OF_REPORT,
	DATE_OF_REPORT_UNIX AS [NEW_DATE_OF_REPORT_UNIX],
	LAG([DATE_OF_REPORT_UNIX], 1, NULL) OVER (ORDER BY [DATE_LAST_INSERTED], [DATE_OF_REPORT_UNIX]) AS [OLD_DATE_OF_REPORT_UNIX],
	LAG(DBO.NO_NEGATIVE_NUMBER_I([TOTAL_REPORTED_LOCATIONS]), 1, NULL) OVER (ORDER BY [DATE_LAST_INSERTED], [DATE_OF_REPORT_UNIX]) AS [OLD_VALUE],
	DBO.NO_NEGATIVE_NUMBER_I([TOTAL_REPORTED_LOCATIONS]) -
		LAG(DBO.NO_NEGATIVE_NUMBER_I([TOTAL_REPORTED_LOCATIONS]), 1, NULL) OVER (ORDER BY [DATE_LAST_INSERTED], [DATE_OF_REPORT_UNIX]) AS [DIFFERENCE]
--  dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.NURSING_HOMES_TOTALS
WHERE DATE_OF_REPORT >=  '2020-03-02 00:00:00.000'
AND DATE_OF_REPORT <  (SELECT MAX(DATE_OF_REPORT) FROM VWSDEST.NURSING_HOMES_TOTALS)
AND DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) 
                            FROM VWSDEST.NURSING_HOMES_TOTALS)

)

SELECT DATE_OF_REPORT
	  ,NEW_DATE_OF_REPORT_UNIX AS NEW_DATE_UNIX
	  ,OLD_DATE_OF_REPORT_UNIX AS OLD_DATE_UNIX
	  ,CASE WHEN OLD_VALUE IS NULL THEN 0 ELSE OLD_VALUE END AS OLD_VALUE
	  ,CASE WHEN [DIFFERENCE] IS NULL THEN 0 ELSE [DIFFERENCE] END AS [DIFFERENCE]
FROM BASE_CTE T1
WHERE DATE_OF_REPORT = (SELECT LAST_DATE_OF_REPORT FROM LAST_DATE_OF_REPORT)