-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSDEST.V_VWS_VACCINE_ADMINISTERED_TOTAL_TEMP AS

	SELECT 
		-- estimated = estimated + reported
		SUM(
			CAST(
				CASE 
					WHEN [REPORT_STATUS] = 'estimated'  
						THEN [VACCINATIONS_AMOUNT] 
					ELSE 0
				END
				AS DECIMAL(19,1))
			) +
		SUM(
			CAST(
				CASE 
					WHEN [REPORT_STATUS] = 'reported'  
						THEN [VACCINATIONS_AMOUNT] 
					ELSE 0
				END
				AS DECIMAL(19,1))
			)												AS [ESTIMATED]
		,SUM(
			CAST(
				CASE 
					WHEN [REPORT_STATUS] = 'reported'  
						THEN [VACCINATIONS_AMOUNT] 
					ELSE 0
				END
				AS DECIMAL(19,1))
			)												AS [REPORTED]
		,dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_STATISTIC)		AS [DATE_UNIX]
		,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)	AS [DATE_OF_INSERTION_UNIX]

	FROM 
		VWSINTER.VACCINE_ADMINISTERED_TEMP
	WHERE
		[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM VWSINTER.VACCINE_ADMINISTERED_TEMP)
	GROUP BY
		dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_STATISTIC)
		,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)