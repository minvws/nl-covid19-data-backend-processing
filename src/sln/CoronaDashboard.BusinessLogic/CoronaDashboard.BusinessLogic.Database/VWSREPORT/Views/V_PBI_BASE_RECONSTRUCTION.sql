-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW [VWSREPORT].[V_PBI_BASE_RECONSTRUCTION] AS

	SELECT
		CAST(DATE_OF_PUBLICATION AS DATE) 		AS [Datum]
		,CAST([DATE_LAST_INSERTED] as date)     AS [Update datum]
		,CASE
			WHEN LEN(SECURITY_REGION_CODE) = 0
				THEN NULL
			ELSE SECURITY_REGION_CODE
		END										AS VR_CODE
		,CASE
			WHEN LEN(MUNICIPALITY_CODE) = 0
				THEN NULL
			ELSE MUNICIPALITY_CODE
		END 									AS GM_CODE
		,TOTAL_REPORTED 						AS [Positieve testen]		
        ,'Huidige rekenmethode'                 AS Reken_filter
	FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY
    WHERE DATE_LAST_INSERTED in (
		SELECT MAX(DATE_LAST_INSERTED)
		FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY
		GROUP BY CAST([DATE_LAST_INSERTED] as date)
	)