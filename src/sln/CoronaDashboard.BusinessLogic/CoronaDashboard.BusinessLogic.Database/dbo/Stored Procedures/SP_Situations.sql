-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
CREATE   PROCEDURE [dbo].[SP_Situations]
AS
BEGIN

    -- Add column with week start and apply mapping
    WITH LATEST_SITUATIONS AS (
        SELECT [DATE_OF_REPORT]
            ,[DATE_OF_PUBLICATION]
            ,DBO.WEEK_START(DATE_OF_PUBLICATION) AS WEEK_START
            ,[SECURITY_REGION_CODE]
            ,[SOURCE_AND_CONTACT_TRACING_PHASE]
            ,CASE
                WHEN SOURCE_AND_CONTACT_TRACING_PHASE = 'high' THEN 1
                WHEN SOURCE_AND_CONTACT_TRACING_PHASE = 'medium' THEN 2
                WHEN SOURCE_AND_CONTACT_TRACING_PHASE = 'low' THEN 3
                WHEN SOURCE_AND_CONTACT_TRACING_PHASE = 'missing' THEN 4
                ELSE 5
             END AS SOURCE_AND_CONTACT_TRACING_PHASE_INT
            ,[TOTAL_REPORTED]
            ,[REPORTS_WITH_SETTINGS]
            ,VWS_CATEGORY
            ,[NUMBER_SETTINGS_REPORTED]
        FROM [VWSINTER].[RIVM_SITUATIONS] S
        LEFT JOIN VWSSTATIC.SITUATIONS_MAPPING M
            ON S.SETTING_REPORTED = SETTING_REPORTED_LABEL
            AND M.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.SITUATIONS_MAPPING)
        WHERE S.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[RIVM_SITUATIONS])
            AND SECURITY_REGION_CODE like 'VR%' -- Explicitly exclude 'Onbekend' label
    )

    -- Add column with boolean if week/SR combination has sufficient measurements
    , SITUATIONS_WITH_BOOLEAN AS (
        SELECT B.*
            ,has_sufficient_responses
        FROM LATEST_SITUATIONS B
        LEFT JOIN (
            SELECT WEEK_START
                ,SECURITY_REGION_CODE
                ,CASE
                    WHEN
                        MAX(SOURCE_AND_CONTACT_TRACING_PHASE_INT) = 1
                    THEN 'true' -- Only true when all values are high for period before 'BCO op maat'
                    WHEN
                        MAX(SOURCE_AND_CONTACT_TRACING_PHASE_INT) <= 2
                        AND WEEK_START >= '2021-11-08 00:00:00.000'
                    THEN 'true' -- BCO op maat: include medium from a specified date
                    ELSE 'false'
                END AS has_sufficient_responses
            FROM LATEST_SITUATIONS
            GROUP BY WEEK_START, SECURITY_REGION_CODE
        ) G
        ON B.WEEK_START = G.WEEK_START
            AND B.SECURITY_REGION_CODE = G.SECURITY_REGION_CODE
    )


    -- Add column with totals and percentage per SR per week
    , SITUATIONS_WITH_TOTALS AS (
        SELECT B.*
            ,REPORTS_WITH_SETTINGS_PER_VR_PER_WEEK
            ,TOTAL_REPORTED_PER_VR_PER_WEEK
            ,situations_known_percentage
        FROM SITUATIONS_WITH_BOOLEAN B
        LEFT JOIN (

            -- Totals and percentage per SR per week
            SELECT SECURITY_REGION_CODE
            ,WEEK_START
            ,SUM(REPORTS_WITH_SETTINGS_PER_VR_PER_DATE_OF_PUBLICATION) AS REPORTS_WITH_SETTINGS_PER_VR_PER_WEEK
            ,SUM(TOTAL_REPORTED_PER_VR_PER_DATE_OF_PUBLICATION) AS TOTAL_REPORTED_PER_VR_PER_WEEK
            ,CAST(ROUND(SUM(REPORTS_WITH_SETTINGS_PER_VR_PER_DATE_OF_PUBLICATION) * 100.0 / SUM(TOTAL_REPORTED_PER_VR_PER_DATE_OF_PUBLICATION), 1) AS DECIMAL(5,1))  AS situations_known_percentage
            FROM (
                -- Totals per SR per day
                SELECT DATE_OF_PUBLICATION
                ,SECURITY_REGION_CODE
                ,DBO.WEEK_START(DATE_OF_PUBLICATION) AS WEEK_START
                -- Check if there are dummy values (-9999). If so, always display NULL
                ,CASE
                    WHEN MIN(REPORTS_WITH_SETTINGS) = -9999  THEN 0
                    ELSE MIN(REPORTS_WITH_SETTINGS)
                END AS REPORTS_WITH_SETTINGS_PER_VR_PER_DATE_OF_PUBLICATION
                ,CASE
                    WHEN MIN(TOTAL_REPORTED) = -9999  THEN 0
                    ELSE MIN(TOTAL_REPORTED)
                END AS TOTAL_REPORTED_PER_VR_PER_DATE_OF_PUBLICATION
                FROM SITUATIONS_WITH_BOOLEAN
                WHERE has_sufficient_responses = 'true'
                GROUP BY DATE_OF_PUBLICATION, SECURITY_REGION_CODE
            ) PER_VR_PER_DATE_OF_PUBLICATION
            GROUP BY SECURITY_REGION_CODE, WEEK_START
        ) TOTALS
        ON B.WEEK_START = TOTALS.WEEK_START
            AND B.SECURITY_REGION_CODE = TOTALS.SECURITY_REGION_CODE
    )

    -- Pivot categories
    , SITUATIONS_PIVOT AS (
        SELECT *
        FROM SITUATIONS_WITH_TOTALS
        PIVOT (
            SUM(NUMBER_SETTINGS_REPORTED)
            FOR VWS_CATEGORY IN (
                [Thuis en bezoek]
                ,[Werk]
                ,[School en kinderopvang]
                ,[Gezondheidszorg]
                ,[Bijeenkomsten]
                ,[Reizen]
                ,[Horeca]
                ,[Overig]
                )
            ) AS pivottable
    )

    -- Insert final output into dest table
    INSERT INTO VWSDEST.RIVM_SITUATIONS
            (
            vrcode
            ,DATE_START
            ,DATE_END
            ,has_sufficient_data
            ,situations_known_percentage
            ,situations_known_total
            ,investigations_total
            ,home_and_visits
            ,work
            ,school_and_day_care
            ,health_care
            ,gathering
            ,travel
            ,hospitality
            ,other
            )
    -- Calculate percentages for each category
    SELECT SECURITY_REGION_CODE AS vrcode
        ,WEEK_START AS DATE_START
        ,DATEADD(day, 6, WEEK_START) AS DATE_END
        ,min(has_sufficient_responses) AS has_sufficient_data
        ,MIN(situations_known_percentage) AS situations_known_percentage
        ,MIN(REPORTS_WITH_SETTINGS_PER_VR_PER_WEEK) AS situations_known_total
        ,MIN(TOTAL_REPORTED_PER_VR_PER_WEEK) AS investigations_total
        -- Check if there is insufficient data or mock data, then NULL, else calculate percentage
        ,CASE WHEN MIN([Thuis en bezoek]) = -9999 OR min(has_sufficient_responses) = 'false' THEN NULL
            ELSE CAST(ISNULL(SUM([Thuis en bezoek]) * 100.0 / MIN(REPORTS_WITH_SETTINGS_PER_VR_PER_WEEK),0) AS DECIMAL(5,1))
         END AS [home_and_visits]
        ,CASE WHEN MIN([Werk]) = -9999 OR min(has_sufficient_responses) = 'false' THEN NULL
            ELSE CAST(ISNULL(SUM([Werk]) * 100.0 / MIN(REPORTS_WITH_SETTINGS_PER_VR_PER_WEEK),0) AS DECIMAL(5,1))
         END AS [work]
        ,CASE WHEN MIN([School en kinderopvang]) = -9999 OR min(has_sufficient_responses) = 'false' THEN NULL
            ELSE CAST(ISNULL(SUM([School en kinderopvang]) * 100.0 / MIN(REPORTS_WITH_SETTINGS_PER_VR_PER_WEEK),0) AS DECIMAL(5,1))
         END AS [school_and_day_care]
        ,CASE WHEN MIN([Gezondheidszorg]) = -9999 OR min(has_sufficient_responses) = 'false' THEN NULL
            ELSE CAST(ISNULL(SUM([Gezondheidszorg]) * 100.0 / MIN(REPORTS_WITH_SETTINGS_PER_VR_PER_WEEK),0) AS DECIMAL(5,1))
         END AS [health_care]
        ,CASE WHEN MIN([Bijeenkomsten]) = -9999 OR min(has_sufficient_responses) = 'false' THEN NULL
            ELSE CAST(ISNULL(SUM([Bijeenkomsten]) * 100.0 / MIN(REPORTS_WITH_SETTINGS_PER_VR_PER_WEEK),0) AS DECIMAL(5,1))
         END AS [gathering]
        ,CASE WHEN MIN([Reizen]) = -9999 OR min(has_sufficient_responses) = 'false' THEN NULL
            ELSE CAST(ISNULL(SUM([Reizen]) * 100.0 / MIN(REPORTS_WITH_SETTINGS_PER_VR_PER_WEEK),0) AS DECIMAL(5,1))
         END AS [travel]
        ,CASE WHEN MIN([Horeca]) = -9999 OR min(has_sufficient_responses) = 'false' THEN NULL
            ELSE CAST(ISNULL(SUM([Horeca]) * 100.0 / MIN(REPORTS_WITH_SETTINGS_PER_VR_PER_WEEK),0) AS DECIMAL(5,1))
         END AS [hospitality]
        ,CASE WHEN MIN([Overig]) = -9999 OR min(has_sufficient_responses) = 'false' THEN NULL
            ELSE CAST(ISNULL(SUM([Overig]) * 100.0 / MIN(REPORTS_WITH_SETTINGS_PER_VR_PER_WEEK),0) AS DECIMAL(5,1))
         END AS [other]
    FROM SITUATIONS_PIVOT
    GROUP BY SECURITY_REGION_CODE, WEEK_START

END