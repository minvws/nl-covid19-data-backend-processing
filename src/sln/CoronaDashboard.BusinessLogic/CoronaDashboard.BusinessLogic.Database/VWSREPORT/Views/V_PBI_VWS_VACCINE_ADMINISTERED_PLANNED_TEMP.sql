-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 CREATE   VIEW VWSREPORT.V_PBI_VWS_VACCINE_ADMINISTERED_PLANNED_TEMP
 AS
 	SELECT 
 		DOSES,
 		DATE_START_UNIX,
 		DATE_END_UNIX,
 		[DATE_LAST_INSERTED]			AS [DATE_OF_INSERTION]
 	FROM VWSDEST.VWS_VACCINE_PLANNED
 	WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.VWS_VACCINE_PLANNED)