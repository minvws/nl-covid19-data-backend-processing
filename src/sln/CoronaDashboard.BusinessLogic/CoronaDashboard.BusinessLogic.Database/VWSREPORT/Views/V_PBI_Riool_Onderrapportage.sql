-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
CREATE   VIEW VWSREPORT.V_PBI_Riool_Onderrapportage AS
-- Riool gegevens, Distinct om duplicates uit data te verwijderen
    SELECT
        CAST([DATE_MEASUREMENT] as date)                                        AS [Datum]
        ,CAST([DATE_LAST_INSERTED] as date)                                     AS [Update datum]
        ,[AVERAGE_RNA_FLOW_PER_100000]							                AS [RNA flow per 100K]
        ,[REGION_COVERED_INHABITANTS]								            AS [Inwoners regio covered]
  FROM [VWSDEST].[SEWER_PROLONGATED]
  WHERE
	REGIO_CODE = 'NL'
	and DATE_LAST_INSERTED in (
        SELECT MAX(DATE_LAST_INSERTED)
        FROM [VWSDEST].[SEWER_PROLONGATED]
        GROUP BY CAST([DATE_LAST_INSERTED] as date)
    )