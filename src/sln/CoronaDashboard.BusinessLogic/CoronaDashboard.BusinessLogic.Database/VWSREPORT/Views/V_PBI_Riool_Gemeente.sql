-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   VIEW VWSREPORT.V_PBI_Riool_Gemeente
AS
	SELECT
		CAST(dbo.CONVERT_UNIX_TO_DATETIME([WEEK_UNIX]) as date)		            AS [Week start]
		,CAST(dbo.WEEK_END(dbo.CONVERT_UNIX_TO_DATETIME([WEEK_UNIX])) as date)  AS [Week einde]
		,CAST([DATE_LAST_INSERTED] as date)     					            AS [Update datum]
		,GMCODE														            AS [GemeenteCode]
		,[AVERAGE_RNA_FLOW_PER_100000]								            AS [RNA flow per 100K]
		,[NUMBER_OF_MEASUREMENTS]										        AS [Aantal metingen]
		,[NUMBER_OF_LOCATIONS]										            AS [Aantal locaties]
		,[TOTAL_LOCATIONS]                                                      AS [Totaal aantal locaties]
	FROM [VWSDEST].[SEWER_MEASUREMENTS_PER_MUNICIPALITY]
	WHERE
		[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[SEWER_MEASUREMENTS_PER_MUNICIPALITY])