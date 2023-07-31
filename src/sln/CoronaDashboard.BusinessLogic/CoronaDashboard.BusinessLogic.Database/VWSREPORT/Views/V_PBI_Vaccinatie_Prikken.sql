-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSREPORT.V_PBI_Vaccinatie_Prikken AS --Similar to [VWSDEST].[V_VWS_VACCINE_ADMINISTERED_BY_SOURCE_TEMP]
-- Vaccinatie_Prikken

	SELECT 
		[SOURCE]											AS [Type]
		,CAST([DATE_OF_STATISTIC] AS DATE)					AS [Datum]
		,CAST([DATE_LAST_INSERTED] as date)     AS [Update datum]
		,SUM(
			CAST(
				CASE 
					WHEN [REPORT_STATUS] = 'estimated'  
						THEN [VACCINATIONS_AMOUNT] 
					ELSE 0
				END
			AS DECIMAL(19,1)))
		+ SUM(
			CAST(
				CASE 
					WHEN [REPORT_STATUS] = 'reported'  
						THEN [VACCINATIONS_AMOUNT] 
					ELSE 0
				END
				AS DECIMAL(19,1)))							AS [Prikken Geschat]
		
		,SUM(CAST(
			CASE 
				WHEN [REPORT_STATUS] = 'reported'  
					THEN [VACCINATIONS_AMOUNT] 
				ELSE 0
			END
			AS DECIMAL(19,1)))								AS [Prikken Gerapporteerd]



	FROM 
		VWSINTER.VACCINE_ADMINISTERED_TEMP
	WHERE
		[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM VWSINTER.VACCINE_ADMINISTERED_TEMP)
	GROUP BY
		[SOURCE],
		[DATE_OF_STATISTIC],
		CAST(DATE_LAST_INSERTED as date),
		dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)