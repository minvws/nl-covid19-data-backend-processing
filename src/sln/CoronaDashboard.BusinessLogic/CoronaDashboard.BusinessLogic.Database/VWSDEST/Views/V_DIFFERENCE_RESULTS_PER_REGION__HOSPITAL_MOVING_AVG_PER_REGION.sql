﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
/****** Object:  View [VWSDEST].[V_DIFFERENCE_RESULTS_PER_REGION__HOSPITAL_MOVING_AVG_PER_REGION]    Script Date: 12-11-2020 15:14:55 ******/

CREATE   VIEW [VWSDEST].[V_DIFFERENCE_RESULTS_PER_REGION__HOSPITAL_MOVING_AVG_PER_REGION] AS

WITH LAST_DATE_OF_REPORT AS (
	SELECT
		VRCODE,
		CAST(MAX(DATE_OF_REPORT) as datetime) AS [LAST_DATE_OF_REPORT]
	FROM VWSDEST.RESULTS_PER_REGION
	WHERE DATE_OF_REPORT >=  '2020-03-16 00:00:00.000'
		AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.RESULTS_PER_REGION)
	GROUP BY VRCODE
),

BASE_CTE AS (
SELECT 
	DATE_OF_REPORT,
	DATE_OF_REPORT_UNIX AS [NEW_DATE_OF_REPORT_UNIX],
	VRCODE,
	LAG([DATE_OF_REPORT_UNIX], 1, NULL) OVER (PARTITION BY [VRCODE] ORDER BY [DATE_LAST_INSERTED], [DATE_OF_REPORT_UNIX]) AS [OLD_DATE_OF_REPORT_UNIX],
    LAG(DBO.NO_NEGATIVE_NUMBER_F(HOSPITAL_MOVING_AVG_PER_REGION), 1, NULL) OVER (PARTITION BY [VRCODE] ORDER BY [DATE_LAST_INSERTED], [DATE_OF_REPORT_UNIX]) AS [OLD_VALUE],
	DBO.NO_NEGATIVE_NUMBER_F(HOSPITAL_MOVING_AVG_PER_REGION) -
		LAG(DBO.NO_NEGATIVE_NUMBER_F(HOSPITAL_MOVING_AVG_PER_REGION), 1, NULL) OVER (PARTITION BY [VRCODE] ORDER BY [DATE_LAST_INSERTED], [DATE_OF_REPORT_UNIX]) AS [DIFFERENCE]
--  dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.RESULTS_PER_REGION
WHERE DATE_OF_REPORT >=  '2020-03-16 00:00:00.000'
AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM VWSDEST.RESULTS_PER_REGION)
)

SELECT DATE_OF_REPORT
	  ,NEW_DATE_OF_REPORT_UNIX AS NEW_DATE_UNIX
	  ,OLD_DATE_OF_REPORT_UNIX AS OLD_DATE_UNIX
	  ,T1.VRCODE
	  ,CASE WHEN OLD_VALUE IS NULL THEN 0 ELSE OLD_VALUE END AS OLD_VALUE
	  ,CASE WHEN [DIFFERENCE] IS NULL THEN 0 ELSE [DIFFERENCE] END AS [DIFFERENCE]
FROM BASE_CTE T1
LEFT JOIN LAST_DATE_OF_REPORT T2
	ON T1.[VRCODE] = T2.[VRCODE]
WHERE DATE_OF_REPORT = LAST_DATE_OF_REPORT
;