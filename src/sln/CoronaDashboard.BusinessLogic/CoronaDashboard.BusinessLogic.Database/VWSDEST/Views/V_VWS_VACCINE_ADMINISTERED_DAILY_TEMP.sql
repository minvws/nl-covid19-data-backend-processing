-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   VIEW VWSDEST.V_VWS_VACCINE_ADMINISTERED_DAILY_TEMP
AS
--CTE containing the total cumulative vaccinations on each day
WITH BASE_CTE AS (
	SELECT 
		 DATE_OF_STATISTIC
		,DATEADD(DAY, -7, DATE_OF_STATISTIC)             AS DATE_WEEK_LAG
		,DATE_LAST_INSERTED
		,CAST(SUM(VACCINATIONS_AMOUNT) AS DECIMAL(19,1)) AS [VACCINATIONS_AMOUNT]
	FROM VWSINTER.VACCINE_ADMINISTERED_TEMP
	  WHERE  DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.VACCINE_ADMINISTERED_TEMP)
      AND REPORT_STATUS IN ('estimated', 'reported')
	GROUP BY DATE_OF_STATISTIC,DATE_LAST_INSERTED
)
,
--CTE containing the weekly increase of vaccinations
WEEKLY_CTE AS (	
	SELECT
		 T0.DATE_OF_STATISTIC									    AS DATE_OF_STATISTIC
		,DATEADD(DAY, 1, T0.DATE_WEEK_LAG)                          AS DATE_START --First day of current week follows last day of previous week
		,T0.DATE_LAST_INSERTED									    AS DATE_LAST_INSERTED
		,T0.[VACCINATIONS_AMOUNT]								
		,T1.[VACCINATIONS_AMOUNT]                                   AS [VACCINATIONS_AMOUNT_LAG]
		,T0.[VACCINATIONS_AMOUNT] - T1.[VACCINATIONS_AMOUNT]        AS DOSES_PER_WEEK
		,(T0.[VACCINATIONS_AMOUNT] - T1.[VACCINATIONS_AMOUNT])/7    AS DOSES_PER_DAY
	FROM BASE_CTE AS T0
	  LEFT JOIN BASE_CTE AS T1 ON T0.DATE_WEEK_LAG = T1.DATE_OF_STATISTIC -- Retrieve data from 7 days old
	WHERE T1.DATE_OF_STATISTIC IS NOT NULL --show data only if previous week is available (and doses per day can be determined)
)
SELECT 
     CAST(FLOOR(DOSES_PER_DAY) AS INT) 											AS [DOSES_PER_DAY]
	--Multiplying by 10 before dividing again lets floor/ceil operation work on 1st decimal
	,CAST(	FLOOR((DOSES_PER_DAY/ 43200.0)*10)	/10 	AS DECIMAL(9,1)) 		AS [DOSES_PER_SECOND] -- 12 working hours * 60 minutes * 60 seconds = 43200 seconds per day
	,CAST(	FLOOR((DOSES_PER_DAY/ 720.0)*10)	/10 	AS DECIMAL(9,1))		AS [DOSES_PER_MINUTE] -- 12 working hours * 60 minutes = 720 minutes per day
	,CAST(	CEILING((43200.0/DOSES_PER_DAY)*10)	/10 	AS DECIMAL(9,1)) 		AS [SECONDS_PER_DOSE] -- 12 working hours * 60 minutes * 60 seconds = 43200 seconds per day
	,dbo.CONVERT_DATETIME_TO_UNIX([DATE_START])									AS [DATE_START_UNIX]
	,dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_STATISTIC)							AS [DATE_END_UNIX]
	,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)							AS [DATE_OF_INSERTION_UNIX]
FROM WEEKLY_CTE