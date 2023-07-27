-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
 
 CREATE   VIEW [VWSDEST].[V_RIVM_SEWER_MEASUREMENTS_NL_2023] AS
     SELECT
         dbo.CONVERT_DATETIME_TO_UNIX([DATE_MEASUREMENT]) AS [DATE_UNIX],
         CAST(round(([RNA_FLOW_PER_100000] / 1.0E+11),0) as INT) AS [AVERAGE],
         dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED]) AS [DATE_OF_INSERTION_UNIX]
     FROM [VWSDEST].[RIVM_SEWER_MEASUREMENTS_NL_2023]
     WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[RIVM_SEWER_MEASUREMENTS_NL_2023]);