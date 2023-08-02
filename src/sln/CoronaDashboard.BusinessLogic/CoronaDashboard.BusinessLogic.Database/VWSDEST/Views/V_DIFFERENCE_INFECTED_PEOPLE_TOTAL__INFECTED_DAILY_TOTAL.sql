-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
/****** Object:  View [VWSDEST].[V_DIFFERENCE_INFECTED_PEOPLE_TOTAL__INFECTED_DAILY_TOTAL]    Script Date: 12-11-2020 14:45:59 ******/

CREATE    VIEW [VWSDEST].[V_DIFFERENCE_INFECTED_PEOPLE_TOTAL__INFECTED_DAILY_TOTAL] AS
WITH LAST_DATE_OF_REPORT AS (
	SELECT
		CAST(MAX(DATE_OF_REPORT) as datetime) AS [LAST_DATE_OF_REPORT]
	FROM VWSDEST.POSITIVE_TESTED_PEOPLE
	WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.POSITIVE_TESTED_PEOPLE)
),

BASE_CTE AS (
SELECT 
    DATE_OF_REPORT,
	DATE_OF_REPORT_UNIX                                                                                                 AS NEW_DATE_UNIX,
	DATE_OF_REPORT_UNIX                                                                                                 AS OLD_DATE_UNIX,
   INFECTED_DAILY_TOTAL AS [NEW_VALUE], -- contains the absolute number for current date
   --Reference value is further rounded from 1 decimal to int. By rounding it from the 1 decimal value it is in line with it.
   CAST(ROUND([7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE],0) AS INT) AS [REF_VALUE] --contains the 7d average of absolute numbers as reference value
FROM VWSDEST.POSITIVE_TESTED_PEOPLE
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                            FROM VWSDEST.POSITIVE_TESTED_PEOPLE)
)

SELECT DATE_OF_REPORT
	  ,NEW_DATE_UNIX
	  ,OLD_DATE_UNIX
    --   ,[NEW_VALUE]
	  ,CASE WHEN REF_VALUE IS NULL THEN 0 ELSE REF_VALUE END AS OLD_VALUE
	  ,CASE WHEN [NEW_VALUE] - [REF_VALUE] IS NULL THEN 0 ELSE [NEW_VALUE] - [REF_VALUE] END AS [DIFFERENCE]
FROM BASE_CTE T1
WHERE DATE_OF_REPORT = (SELECT LAST_DATE_OF_REPORT FROM LAST_DATE_OF_REPORT)