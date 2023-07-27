-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSREPORT.V_PBI_Veiligheidsregio AS
-- Veiligheidsregio's
	SELECT 
		--[ID]	
		 [VGRNR]										AS [VeiligheidsregioCode]
		,CASE
			WHEN VGRNR = 'VR02' THEN 'Friesland'
			ELSE VGRNAAM
		END  											AS [Veiligheidsregio]
		,[INHABITANTS]									AS [Inwoners]
		,CAST([DATE_LAST_INSERTED] as date)     		AS [Update datum]
	FROM [VWSSTATIC].[INHABITANTS_PER_SAFETY_REGION]
	WHERE
	[DATE_LAST_INSERTED] = 
		(SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTATIC].[INHABITANTS_PER_SAFETY_REGION])