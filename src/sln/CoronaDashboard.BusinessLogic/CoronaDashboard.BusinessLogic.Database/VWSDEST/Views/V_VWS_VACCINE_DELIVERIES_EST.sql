-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   VIEW VWSDEST.V_VWS_VACCINE_DELIVERIES_EST AS
 SELECT 
      [VALUE] AS TOTAL
     ,DATE_START_UNIX
     ,DATE_END_UNIX
     ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
 FROM VWSDEST.VWS_VACCINE_DELIVERIES 
   WHERE [DATE_LAST_INSERTED] = (SELECT MAX ([DATE_LAST_INSERTED]) FROM [VWSDEST].[VWS_VACCINE_DELIVERIES])
   AND REPORT_STATUS = 'estimated'