-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
 
 CREATE   VIEW [VWSREPORT].[V_PBI_Riool_Dagwaarden]
 AS
 -- Riool gegevens
     SELECT
         CAST([DATE_MEASUREMENT] AS DATE)                                       AS [Datum]
         ,CAST(dbo.WEEK_START([DATE_MEASUREMENT]) AS DATE)                      AS [Week start]
         ,CAST(dbo.WEEK_END([DATE_MEASUREMENT]) AS DATE)                        AS [Week einde]
         ,CAST([DATE_LAST_INSERTED] AS DATE)                                    AS [Update datum]
         ,CAST(([RNA_FLOW_PER_100000] / 1.0E+11) AS [DECIMAL](16, 3))           AS [RNA flow per 100K]
         ,NULL                                                                  AS [Inwoners regio covered]
         ,NULL                                                                  AS [RNA flow per 100K dagwaarde]
   FROM [VWSDEST].[RIVM_SEWER_MEASUREMENTS_NL_2023]
   WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_SEWER_MEASUREMENTS_NL_2023])