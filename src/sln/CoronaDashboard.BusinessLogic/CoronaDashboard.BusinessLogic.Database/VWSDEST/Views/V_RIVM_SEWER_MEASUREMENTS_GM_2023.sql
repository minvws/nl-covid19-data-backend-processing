-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
 
 CREATE   VIEW [VWSDEST].[V_RIVM_SEWER_MEASUREMENTS_GM_2023] AS
     SELECT
         [GMCODE],
         [DATE_START_UNIX],
         [DATE_END_UNIX],
         [AVERAGE],
         CASE WHEN dbo.WEEK_START(dbo.CONVERT_UNIX_TO_DATETIME([DATE_START_UNIX])) < dateadd(day, -14, dbo.WEEK_START(DATE_LAST_INSERTED)) THEN 'true' ELSE 'false' END AS [DATA_IS_OUTDATED],
         dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED]) AS [DATE_OF_INSERTION_UNIX]
     FROM [VWSDEST].[RIVM_SEWER_MEASUREMENTS_GM_2023]
     WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[RIVM_SEWER_MEASUREMENTS_GM_2023]);