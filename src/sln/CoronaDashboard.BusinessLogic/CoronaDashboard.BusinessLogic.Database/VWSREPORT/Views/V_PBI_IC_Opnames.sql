-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   VIEW VWSREPORT.V_PBI_IC_Opnames AS
	SELECT
		CAST(DATE_OF_STATISTICS as date)			AS [Datum]
		,CAST([DATE_LAST_INSERTED] as date)     	AS [Update datum]
        ,IC_ADMISSION                           	AS [IC Opnames]
		,IC_ADMISSION_7D_AVG						AS [IC Opnames (7D gemiddelde)]
		,IC_ADMISSION_NOTIFICATION                 	AS [IC Opnames Gemeld]
		,IC_ADMISSION_NOTIFICATION_7D_AVG			AS [IC Opnames Gemeld (7D gemiddelde)]
	FROM VWSDEST.RIVM_IC_OPNAME
    WHERE
		RIVM_IC_OPNAME.DATE_LAST_INSERTED=(
			SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.RIVM_IC_OPNAME
			) AND IC_ADMISSION_7D_AVG IS NOT NULL