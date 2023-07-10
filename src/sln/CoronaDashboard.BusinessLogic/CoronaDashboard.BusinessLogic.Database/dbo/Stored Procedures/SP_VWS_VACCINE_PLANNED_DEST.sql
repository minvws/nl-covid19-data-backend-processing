-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   PROCEDURE [dbo].[SP_VWS_VACCINE_PLANNED_DEST]
 AS
 BEGIN
 WITH
 		PlannedAdministered ([DATE_FIRST_DAY], [DATE_LAST_INSERTED], REPORT_STATUS, [VALUE])
 		AS (
 			SELECT
 				 CAST(DATE_FIRST_DAY as date)															AS [DATE_FIRST_DAY]
 				,CAST(DATE_LAST_INSERTED as date)														AS [DATE_LAST_INSERTED]
 				,REPORT_STATUS
 				,SUM([VALUE])																			AS [VALUE]
 	
 			FROM 
 				VWSINTER.VWS_VACCINE_DELIVERIES_ADMINISTERED
 			WHERE
 				VALUE_TYPE = 'vaccine_administered' AND
 				DATE_LAST_INSERTED = 
 					(SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.VWS_VACCINE_DELIVERIES_ADMINISTERED)
 			GROUP BY
 				CAST(DATE_FIRST_DAY as date)
 				,CAST(DATE_LAST_INSERTED as date)
 				,REPORT_STATUS
 		),
 		PlannedAdministered2 ([DOSES],[DATE_START],[DATE_END],[DATE_LAST_INSERTED])
 		AS (
 			SELECT
 				 [VALUE] - LAG([VALUE],1,0) OVER (ORDER BY DATE_FIRST_DAY ASC)							AS [DOSES]
 				,DATE_FIRST_DAY																			AS [DATE_START]
 				,DATEADD(day,-1,LEAD(DATE_FIRST_DAY,1,NULL) OVER (ORDER BY DATE_FIRST_DAY ASC))			AS [DATE_END]
 				,DATE_LAST_INSERTED																		AS [DATE_LAST_INSERTED]
 		
 			FROM 
 				PlannedAdministered
 		)
 
         INSERT INTO VWSDEST.VWS_VACCINE_PLANNED
         (
             [DOSES]
             ,DATE_START_UNIX
             ,DATE_END_UNIX
         )
 		SELECT 
 			[DOSES]
 			,dbo.CONVERT_DATETIME_TO_UNIX([DATE_START])			AS [DATE_START_UNIX]
 			,dbo.CONVERT_DATETIME_TO_UNIX([DATE_END])			AS [DATE_END_UNIX]
 		FROM
 			PlannedAdministered2
 		WHERE
 			DATE_START <= CAST(GETDATE() as date) AND
 			CAST(GETDATE() as date) <= DATE_END
 END;