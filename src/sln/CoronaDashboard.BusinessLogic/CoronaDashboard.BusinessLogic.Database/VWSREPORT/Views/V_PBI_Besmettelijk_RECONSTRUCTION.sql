  CREATE   VIEW [VWSREPORT].[V_PBI_Besmettelijk_RECONSTRUCTION] AS
    SELECT
        CAST([DATE] as date)                            AS [Datum]
    --,   PREV_LOW                                        AS [Besmettelijk ondergrens]
    ,   PREV_AVG                                        AS [Besmettelijk]
    --,   PREV_UP                                         AS [Besmettelijk bovengrens]
    ,   CAST([DATE_LAST_INSERTED] as date)              AS [Update datum]
    FROM
        VWSINTER.RIVM_INFECTIOUS_PEOPLE
    WHERE
        PREV_AVG IS NOT NULL and
        [DATE_LAST_INSERTED] in (
            SELECT MAX([DATE_LAST_INSERTED])
            FROM VWSINTER.RIVM_INFECTIOUS_PEOPLE
            GROUP BY CAST([DATE_LAST_INSERTED] as date)
    )