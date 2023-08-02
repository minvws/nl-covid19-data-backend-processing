-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   VIEW VWSREPORT.V_PBI_Riool_Veiligheidsregio_Dagwaarden
AS

    WITH calc_differences AS (
        SELECT
            CAST([DATE_MEASUREMENT] as date)                                        AS [Datum]
            ,CAST(dbo.CONVERT_UNIX_TO_DATETIME([WEEK_UNIX]) as date)		        AS [Week start]
            ,CAST(dbo.WEEK_END(dbo.CONVERT_UNIX_TO_DATETIME([WEEK_UNIX])) as date)  AS [Week einde]
            ,CAST([DATE_LAST_INSERTED] as date)    						            AS [Update datum]
            ,REGIO_CODE														        AS [VeiligheidsregioCode]
            ,[AVERAGE_RNA_FLOW_PER_100000]								            AS [RNA flow per 100K]
        FROM [VWSDEST].[SEWER_PROLONGATED]
        WHERE
            [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[SEWER_PROLONGATED])
            and
	        REGIO_CODE like 'VR%'
    )
    SELECT [Datum]
        ,[Week start]
        ,[Week einde]
        ,[Update datum]
        ,[VeiligheidsregioCode]
        ,[RNA flow per 100K]
    FROM calc_differences