-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE    VIEW VWSDEST.V_VWS_VACCINE_DELIVERIES_WEEKLY_TIMESPAN AS
 SELECT 
      SUM(TOTAL_VALUE)          AS doses
     ,COUNT(*)                  AS time_span_weeks
     ,MIN([DATE_START_UNIX])    AS [DATE_START_UNIX]
     ,MAX([DATE_END_UNIX])      AS [DATE_END_UNIX]
     ,MAX(dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_REPORT]))          AS [DATE_OF_REPORT_UNIX]
     ,MAX(dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED]))      AS [DATE_OF_INSERTION_UNIX]
 
   FROM [VWSDEST].[VWS_VACCINE_DELIVERIES_WEEKLY]
   WHERE [DATE_LAST_INSERTED] = (SELECT MAX ([DATE_LAST_INSERTED]) FROM [VWSDEST].[VWS_VACCINE_DELIVERIES_WEEKLY])
         AND [REPORT_STATUS] = 'estimated'