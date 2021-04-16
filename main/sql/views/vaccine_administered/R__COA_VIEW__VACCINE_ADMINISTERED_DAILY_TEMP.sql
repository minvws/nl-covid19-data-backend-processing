-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER VIEW VWSDEST.V_VWS_VACCINE_ADMINISTERED_DAILY_TEMP
AS
	WITH ReportedEstimatedBySource (DATE_OF_STATISTIC,DATE_LAST_INSERTED,[SOURCE],[ReportedEstimated])
	AS (
		SELECT
			DATE_OF_STATISTIC
			,DATE_LAST_INSERTED
			,[SOURCE]
			-- If reported is filled, use reported, else use estimated
			,COALESCE(
				 SUM(CASE WHEN [REPORT_STATUS] = 'reported' THEN [VACCINATIONS_AMOUNT] END)	
				,SUM(CASE WHEN [REPORT_STATUS] = 'estimated' THEN [VACCINATIONS_AMOUNT] END)
			)																		AS [ReportedEstimated]
		FROM 
			VWSINTER.VACCINE_ADMINISTERED_TEMP
		WHERE
			[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM VWSINTER.VACCINE_ADMINISTERED_TEMP)
		GROUP BY
			DATE_OF_STATISTIC
			,DATE_LAST_INSERTED
			,[SOURCE]
	),
	ReportedEstimatedDaily (DATE_OF_STATISTIC,DATE_LAST_INSERTED,[ReportedEstimated])
	AS
	(	SELECT
			DATE_OF_STATISTIC
			,DATE_LAST_INSERTED
			,SUM([ReportedEstimated])												AS [ReportedEstimated]
		FROM 
			ReportedEstimatedBySource
		WHERE
			[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM VWSINTER.VACCINE_ADMINISTERED_TEMP)
		GROUP BY
			DATE_OF_STATISTIC
			,DATE_LAST_INSERTED
	),
	DailyDoses (DATE_OF_STATISTIC,[DATE_START],DATE_LAST_INSERTED,[ReportedEstimated], [Doses])
	AS (	
		SELECT
			DATE_OF_STATISTIC									AS DATE_OF_STATISTIC
			,LAG(DATE_OF_STATISTIC,6) OVER (ORDER BY DATE_OF_STATISTIC ASC)
																AS [DATE_START]
			,DATE_LAST_INSERTED									AS DATE_LAST_INSERTED
			,[ReportedEstimated]								AS [ReportedEstimated]
			,[ReportedEstimated] - LAG([ReportedEstimated],1,0) 
				OVER (ORDER BY DATE_OF_STATISTIC ASC)												
																AS [DailyDoses]
		FROM 
			ReportedEstimatedDaily
	)
	
	SELECT
		-- 7 daags gemiddelde gedeeld door 43200 (seconden per dag dat geprikt word)		
		AVG([Doses])
			OVER (ORDER BY DATE_OF_STATISTIC ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
																				AS [DOSES_PER_DAY]
		,CAST(
            FLOOR(
                AVG([Doses])
			OVER (ORDER BY DATE_OF_STATISTIC ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
			/ 43200.0 * 10)	/ 10	AS DECIMAL(4,1))							AS [DOSES_PER_SECOND]
		,CAST(
            CEILING(
                43200.0 / AVG([Doses])
			        OVER (ORDER BY DATE_OF_STATISTIC ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
			        * 10) / 10 AS DECIMAL(4,1))									AS [SECONDS_PER_DOSE]
		
		,dbo.CONVERT_DATETIME_TO_UNIX([DATE_START])								AS [DATE_START_UNIX]
		,dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_STATISTIC)						AS [DATE_END_UNIX]
		,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)						AS [DATE_OF_INSERTION_UNIX]
		
	FROM 
		DailyDoses
	WHERE
		-- show only data if week average is available
		[DATE_START] IS NOT NULL