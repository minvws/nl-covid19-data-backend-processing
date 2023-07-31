-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   VIEW [VWSREPORT].[V_PBI_Mutaties]
AS
    SELECT
         DATE_OF_REPORT                                 AS Datum_report
        ,DATE_OF_STATISTICS_WEEK_START                  AS Datum_week_start
        ,dbo.WEEK_END(DATE_OF_STATISTICS_WEEK_START)    AS Datum_week_eind
        ,LOWER([VARIANT_NAME])                          AS Variant_naam
        ,[IS_VARIANT_OF_CONCERN]                        AS Is_variant_of_concert
        ,[SAMPLE_SIZE]                                  AS Steekproef_grootte
        ,[VARIANT_CASES]                                AS Aantal_cases
        ,VARIANT_PERCENTAGE                             AS Percentage
        ,DATE_LAST_INSERTED                             AS [Update datum]
    FROM [VWSDEST].[RIVM_MUTATIONS]
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_MUTATIONS])

    UNION ALL

    -- Add all other variants as type 'other calculated'
    SELECT
         DATE_OF_REPORT
        ,DATE_OF_STATISTICS_WEEK_START
        ,dbo.WEEK_END(DATE_OF_STATISTICS_WEEK_START)
        ,'overige varianten'
        ,'false'
        ,NULL
        ,NULL
        ,VARIANT_PERCENTAGE
        ,DATE_LAST_INSERTED
    FROM (
        SELECT
             DATE_OF_REPORT
            ,DATE_OF_STATISTICS_WEEK_START
            ,100 - sum(VARIANT_PERCENTAGE) AS VARIANT_PERCENTAGE
            ,DATE_LAST_INSERTED
        FROM [VWSDEST].[RIVM_MUTATIONS]
        WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_MUTATIONS])
        AND IS_VARIANT_OF_CONCERN = 'true'
        GROUP BY
             DATE_OF_REPORT
            ,DATE_OF_STATISTICS_WEEK_START
            ,DATE_LAST_INSERTED
    ) other_calculated