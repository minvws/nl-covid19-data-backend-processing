CREATE   VIEW[VWSREPORT].[V_PBI_GGD_RECONSTRUCTION]
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
        TESTED_WITH_RESULT > 0 AND
        -- Make sure that last three days(including today) are filtered out
        DATEDIFF(DAY, DATE_OF_STATISTICS, DATE_OF_REPORT) > 1 AND
        [DATE_LAST_INSERTED] in (
            SELECT MAX([DATE_LAST_INSERTED])
            FROM VWSINTER.GGD_TESTED_PEOPLE
            GROUP BY CAST([DATE_LAST_INSERTED] as date)
    )