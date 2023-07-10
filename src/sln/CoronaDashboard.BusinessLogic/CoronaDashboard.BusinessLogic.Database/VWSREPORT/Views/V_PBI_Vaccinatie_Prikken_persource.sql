-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSREPORT.V_PBI_Vaccinatie_Prikken_persource AS --Similar to [VWSDEST].[V_VWS_VACCINE_ADMINISTERED_BY_SOURCE_TEMP]
-- Vaccinatie_Prikken

with pivot_for_source as  (SELECT
		CAST([DATE_OF_STATISTIC] AS DATE)					AS [Datum]
		,CAST([DATE_LAST_INSERTED] as date)                 AS [Update datum]
		,SUM(
			CAST(
				CASE
					WHEN [REPORT_STATUS] = 'estimated'  and [SOURCE] = 'GGD'
						THEN [VACCINATIONS_AMOUNT]
					ELSE 0
				END
			AS DECIMAL(19,1)))
		+ SUM(
			CAST(
				CASE
					WHEN [REPORT_STATUS] = 'reported' and [SOURCE] = 'GGD'
						THEN [VACCINATIONS_AMOUNT]
					ELSE 0
				END
				AS DECIMAL(19,1)))							AS [Prikken Geschat GGD]
    	,SUM(
			CAST(
				CASE
					WHEN [REPORT_STATUS] = 'estimated'  and [SOURCE] = 'huisartsen'
						THEN [VACCINATIONS_AMOUNT]
					ELSE 0
				END
			AS DECIMAL(19,1)))
		+ SUM(
			CAST(
				CASE
					WHEN [REPORT_STATUS] = 'reported' and [SOURCE] = 'huisartsen'
						THEN [VACCINATIONS_AMOUNT]
					ELSE 0
				END
				AS DECIMAL(19,1)))							AS [Prikken Geschat huisartsen]
    	,SUM(
			CAST(
				CASE
					WHEN [REPORT_STATUS] = 'estimated'  and [SOURCE] = 'instellingen_zkh'
						THEN [VACCINATIONS_AMOUNT]
					ELSE 0
				END
			AS DECIMAL(19,1)))
		+ SUM(
			CAST(
				CASE
					WHEN [REPORT_STATUS] = 'reported' and [SOURCE] = 'instellingen_zkh'
						THEN [VACCINATIONS_AMOUNT]
					ELSE 0
				END
				AS DECIMAL(19,1)))							AS [Prikken Geschat instellingen_zkh]
		,SUM(CAST(
			CASE
				WHEN [REPORT_STATUS] = 'reported'  and [SOURCE] = 'GGD'
					THEN [VACCINATIONS_AMOUNT]
				ELSE 0
			END
			AS DECIMAL(19,1)))								AS [Prikken Gerapporteerd GGD]
		,SUM(CAST(
			CASE
				WHEN [REPORT_STATUS] = 'reported'  and [SOURCE] = 'huisartsen'
					THEN [VACCINATIONS_AMOUNT]
				ELSE 0
			END
			AS DECIMAL(19,1)))								AS [Prikken Gerapporteerd huisartsen]
 		,SUM(CAST(
			CASE
				WHEN [REPORT_STATUS] = 'reported'  and [SOURCE] = 'instellingen_zkh'
					THEN [VACCINATIONS_AMOUNT]
				ELSE 0
			END
			AS DECIMAL(19,1)))								AS [Prikken Gerapporteerd instellingen_zkh]
        ,SUM(CAST(
			CASE
				WHEN [REPORT_STATUS] = 'estimated'  and [SOURCE] = 'totaal'
					THEN [VACCINATIONS_AMOUNT]
				ELSE 0
			END
			AS DECIMAL(19,1)))								AS [Totaal geschat]  -- de nieuwe splitsing regels hebben geen totaal in bronbestand

	FROM
		VWSINTER.VACCINE_ADMINISTERED_TEMP
	WHERE
		[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM VWSINTER.VACCINE_ADMINISTERED_TEMP)
	GROUP BY
		[DATE_OF_STATISTIC],
		CAST(DATE_LAST_INSERTED as date),
		dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) )

    Select *
    ,isnull([Prikken Geschat GGD],0) + isnull([Prikken Geschat huisartsen],0) + isnull([Prikken Geschat instellingen_zkh],0) +isnull([Totaal geschat],0)  as [Berekend totaal Geschat]
    ,isnull([Prikken Gerapporteerd GGD],0) + isnull([Prikken Gerapporteerd huisartsen],0) + isnull([Prikken Gerapporteerd instellingen_zkh],0)  as [Berekend totaal Gerapporteerd]
    FROM pivot_for_source