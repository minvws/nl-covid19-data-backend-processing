-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   VIEW VWSREPORT.V_PBI_GGD
-- Alleen GGD teststraten
AS
    SELECT
        CAST(DATE_OF_STATISTICS as date)        AS [Datum]
        ,CAST([DATE_LAST_INSERTED] as date)     AS [Update datum]
       ,CASE
            WHEN LEN(SECURITY_REGION_CODE) = 0
            THEN NULL
            ELSE SECURITY_REGION_CODE
        END                                     AS [VR_CODE]
       ,TESTED_WITH_RESULT                      AS [Getest]
       ,TESTED_POSITIVE                         AS [Positief getest]
    FROM 
        VWSINTER.GGD_TESTED_PEOPLE
    WHERE 
        DATE_LAST_INSERTED = (
            SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[GGD_TESTED_PEOPLE]
        ) AND 
        -- Make sure that last three days(including today) are filtered out
        DATEDIFF(DAY, DATE_OF_STATISTICS, DATE_OF_REPORT) > 1