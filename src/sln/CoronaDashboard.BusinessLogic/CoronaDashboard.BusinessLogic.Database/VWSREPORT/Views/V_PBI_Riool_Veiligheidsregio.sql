-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   VIEW VWSREPORT.V_PBI_Riool_Veiligheidsregio
AS
    WITH calc_differences AS (
        SELECT
            CAST(dbo.CONVERT_UNIX_TO_DATETIME([WEEK_UNIX]) as date)		            AS [Week start]
            ,CAST(dbo.WEEK_END(dbo.CONVERT_UNIX_TO_DATETIME([WEEK_UNIX])) as date)  AS [Week einde]
            ,CAST([DATE_LAST_INSERTED] as date)    						            AS [Update datum]
            ,VRCODE														            AS [VeiligheidsregioCode]
            ,[AVERAGE_RNA_FLOW_PER_100000]								            AS [RNA flow per 100K]
            ,[NUMBER_OF_MEASUREMENTS]									            AS [Aantal metingen]
            ,[NUMBER_OF_LOCATIONS]										            AS [Aantal locaties]
            ,[TOTAL_LOCATIONS]                                                      AS [Totaal aantal locaties]
            ,LAG([AVERAGE_RNA_FLOW_PER_100000],1) OVER (PARTITION BY VRCODE ORDER BY WEEK_UNIX ASC)  AS [RNA flow per 100K prev week]
        FROM [VWSDEST].[SEWER_MEASUREMENTS_PER_REGION]
        WHERE
            [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[SEWER_MEASUREMENTS_PER_REGION])
    )
    SELECT [Week start]
        ,[Week einde]
        ,[Update datum]
        ,[VeiligheidsregioCode]
        ,[RNA flow per 100K]
        ,[Aantal metingen]
        ,[Aantal locaties]
        ,[Totaal aantal locaties]
        ,[RNA flow per 100K prev week]
        ,[RNA flow per 100K] - [RNA flow per 100K prev week] AS [Absoluut verschil tov vorige week]
        ,([RNA flow per 100K] - [RNA flow per 100K prev week]) / [RNA flow per 100K prev week] AS [Relatief verschil tov vorige week]
    FROM calc_differences