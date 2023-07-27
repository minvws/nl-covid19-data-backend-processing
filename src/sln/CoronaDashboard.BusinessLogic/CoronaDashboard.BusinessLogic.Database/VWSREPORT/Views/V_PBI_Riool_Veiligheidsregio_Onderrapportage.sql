-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
CREATE   VIEW VWSREPORT.V_PBI_Riool_Veiligheidsregio_Onderrapportage
AS
    SELECT
        CAST([DATE_MEASUREMENT] as date)                                        AS [Datum]
        ,CAST([DATE_LAST_INSERTED] as date)    						            AS [Update datum]
        ,REGIO_CODE														        AS [VeiligheidsregioCode]
        ,[AVERAGE_RNA_FLOW_PER_100000]								            AS [RNA flow per 100K]
    FROM [VWSDEST].[SEWER_PROLONGATED]
    WHERE
    --Include records that are loaded into the database up to 3 months before last insert
        DATE_LAST_INSERTED >= DATEADD(month, -3, (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[SEWER_PROLONGATED]))
        and
	    REGIO_CODE like 'VR%'
	    and DATE_LAST_INSERTED in (
            SELECT MAX(DATE_LAST_INSERTED)
            FROM [VWSDEST].[SEWER_PROLONGATED]
            GROUP BY CAST([DATE_LAST_INSERTED] as date)
    )