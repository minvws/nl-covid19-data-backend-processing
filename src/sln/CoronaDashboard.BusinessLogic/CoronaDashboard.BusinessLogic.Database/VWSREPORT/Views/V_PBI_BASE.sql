-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSREPORT.V_PBI_BASE AS
-- Totaal cijfers
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
		,PROVINCE 								AS [Provincie]
		,[ROAZ_REGION]							AS [Acute Zorg Euregio (ROAZ)]
		,[MUNICIPAL_HEALTH_SERVICE]				AS [GGD]
		,TOTAL_REPORTED 						AS [Positieve testen]		
		,HOSPITAL_ADMISSION						AS [Ziekenhuis opnames]
		,DECEASED								AS [Sterfte]
	FROM 
		VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY
	WHERE
		DATE_LAST_INSERTED = 
			(SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY)