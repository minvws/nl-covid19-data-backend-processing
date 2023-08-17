-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW [VWSREPORT].[V_PBI_HOSPITAL_NICE_RECONSTRUCTION] AS

    -- WITH LastFileFromDate
    -- AS
    -- (
    --     SELECT
    --         CAST([DATE_LAST_INSERTED] as date)  AS DATE_LAST_INSERTED
    --         ,MAX(DATE_LAST_INSERTED)            AS DATE_LAST_INSERTED_MAX
    --     FROM  VWSINTER.[NICE_HOSPITAL]
    --     GROUP BY
    --         CAST([DATE_LAST_INSERTED] as date)
    -- )

    SELECT
        CAST(DATE_OF_STATISTICS as date)                            AS [Datum]
        ,CAST([DATE_LAST_INSERTED] as date)                         AS [Update datum]
    --,   CAST([DATE_OF_REPORT] as date)                              AS [Rapportage Datum]
    ,   [VR_CODE]                                                   AS [VeiligheidsregioCode]
    ,   REPORTED                                                    AS [Gerapporteerd]
    ,   HOSPITALIZED                                                AS [Ziekenhuisopnames]
    ,   HOSPITALIZED_7D_AVG                                         AS [Ziekenhuisopnames 7d gem]
    FROM
       VWSDEST.[NICE_HOSPITAL_VR]
    -- INNER JOIN
    --     LastFileFromDate ON
    --     DATE_LAST_INSERTED_MAX = NICE_HOSPITAL.[DATE_LAST_INSERTED]
    WHERE [DATE_LAST_INSERTED] in (
            SELECT MAX([DATE_LAST_INSERTED])
            FROM VWSDEST.[NICE_HOSPITAL_VR]
            GROUP BY CAST([DATE_LAST_INSERTED] as date)
    )