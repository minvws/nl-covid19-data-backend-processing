-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
/****** Object:  View [VWSDEST].[V_DIFFERENCE_RESULTS_PER_REGION__TOTAL_REPORTED_INCREASE_PER_REGION]    Script Date: 12-11-2020 15:20:25 ******/

CREATE    VIEW [VWSDEST].[V_DIFFERENCE_RESULTS_PER_REGION__TOTAL_REPORTED_INCREASE_PER_REGION] AS

WITH LAST_DATE_OF_REPORT AS (
	SELECT
		VRCODE,
		CAST(MAX(DATE_OF_REPORT) as datetime) AS [LAST_DATE_OF_REPORT]
	FROM VWSDEST.RESULTS_PER_REGION WITH(NOLOCK)
	WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.RESULTS_PER_REGION WITH(NOLOCK))
	GROUP BY VRCODE
),

BASE_CTE AS (
SELECT 
    DATE_OF_REPORT,
	DATE_OF_REPORT_UNIX                                                                                                 AS NEW_DATE_UNIX,
	DATE_OF_REPORT_UNIX                                                                                                 AS OLD_DATE_UNIX,
	VRCODE,
   TOTAL_REPORTED_INCREASE_PER_REGION AS [NEW_VALUE], -- contains the absolute number for current date
   --Reference value is further rounded from 1 decimal to int. By rounding it from the 1 decimal value it is in line with it.
   CAST(ROUND([7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE],0) AS INT) AS [REF_VALUE] --contains the 7d average of absolute numbers as reference value
FROM VWSDEST.RESULTS_PER_REGION WITH(NOLOCK)
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                            FROM VWSDEST.RESULTS_PER_REGION WITH(NOLOCK))
)

SELECT DATE_OF_REPORT
	  ,NEW_DATE_UNIX
	  ,T1.VRCODE
	  ,OLD_DATE_UNIX
    --   ,[NEW_VALUE]
	  ,CASE WHEN REF_VALUE IS NULL THEN 0 ELSE REF_VALUE END AS OLD_VALUE
	  ,CASE WHEN [NEW_VALUE] - [REF_VALUE] IS NULL THEN 0 ELSE [NEW_VALUE] - [REF_VALUE] END AS [DIFFERENCE]
FROM BASE_CTE T1
LEFT JOIN LAST_DATE_OF_REPORT T2
	ON T1.[VRCODE] = T2.[VRCODE]
WHERE DATE_OF_REPORT = LAST_DATE_OF_REPORT
;