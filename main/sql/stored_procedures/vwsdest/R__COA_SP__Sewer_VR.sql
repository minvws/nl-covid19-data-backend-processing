-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
CREATE OR ALTER PROCEDURE [dbo].[SP_SEWER_VR]
AS
BEGIN
-- Calculate percentages and inhabitants for each RWZI for each VR
WITH Percentages AS (
        SELECT CODE_RWZI
        ,GEBIEDSCODE
        ,INHABITANTS
        ,Percentage / 100 AS PERCENTAGE
        FROM [VWSSTATIC].[RWZI_INHIBITANTS_2021]
        WHERE GEBIEDSCODE LIKE 'VR%'
        AND DATE_LAST_INSERTED = (select max(DATE_LAST_INSERTED) from VWSSTATIC.RWZI_INHIBITANTS_2021)
        AND PERCENTAGE != 0
        -- Add exceptions
        -- Add Aalst
        UNION SELECT 9029, 'VR08', 10495, 1.00
        -- Add Lienden
        UNION SELECT 9043, 'VR08', 6728, 1.00
)
-- Calculate average per RWZI per week
,BASE_CTE AS (
    SELECT WEEK_GEM_PER_RWZI.*
    ,GEBIEDSCODE
    ,CASE
        -- Adjust for Zaltbommel
        WHEN RWZI_AWZI_CODE = 9041 AND WEEK_UNIX < 1601856000 THEN (41974 * PERCENTAGE)
        -- Adjust for Tiel
        WHEN RWZI_AWZI_CODE = 9025 AND WEEK_UNIX < 1607299200 THEN (56015 * PERCENTAGE)
        ELSE (INHABITANTS * PERCENTAGE)
    END AS APPLICABLE_INHABITANTS
    ,CASE
        -- Adjust for Zaltbommel
        WHEN RWZI_AWZI_CODE = 9041 AND WEEK_UNIX < 1601856000 THEN ((AVG_RNA_FLOW_PER_100000_PER_RWZI / 100000 ) * (41974 * PERCENTAGE))
        -- Adjust for Tiel
        WHEN RWZI_AWZI_CODE = 9025 AND WEEK_UNIX < 1607299200 THEN ((AVG_RNA_FLOW_PER_100000_PER_RWZI / 100000 ) * (56015 * PERCENTAGE))
        ELSE (AVG_RNA_FLOW_PER_100000_PER_RWZI / 100000 ) * (INHABITANTS * PERCENTAGE)
    END AS AVG_RNA_FLOW_PER_RWZI
    FROM (
        SELECT
        SB.RWZI_AWZI_CODE,
        WEEK_UNIX,
        AVG(RNA_FLOW_PER_100000) / 1.0E+11 as AVG_RNA_FLOW_PER_100000_PER_RWZI
        , count(*) AS NUMBER_OF_MEASUREMENTS
        FROM VWSDEST.SEWER_BASE SB
        where DATE_LAST_INSERTED = (select max(DATE_LAST_INSERTED) from VWSDEST.SEWER_BASE)
        -- keep only the first measurement (some duplicate measurements per day per RWZI are present)
        and COUNT_DAILY_MEASUREMENT=1
        -- Take the average of the measurements for 1 RWZI for 1 week
        group by RWZI_AWZI_CODE, WEEK_UNIX
    ) WEEK_GEM_PER_RWZI
    -- Add percentages and inhabitants for each RWZI for each VR
    LEFT JOIN Percentages
        ON WEEK_GEM_PER_RWZI.RWZI_AWZI_CODE = Percentages.CODE_RWZI
)

INSERT INTO VWSDEST.SEWER_MEASUREMENTS_PER_REGION(
        WEEK_UNIX
    ,   VRCODE
    ,   AVERAGE_RNA_FLOW_PER_100000
    ,   NUMBER_OF_MEASUREMENTS
    ,   NUMBER_OF_LOCATIONS
    ,   TOTAL_LOCATIONS
)

SELECT
    WEEK_UNIX
,   B.GEBIEDSCODE
,   ROUND((SUM(AVG_RNA_FLOW_PER_RWZI) / SUM(APPLICABLE_INHABITANTS)) * 100000 , 2) as AVERAGE_RNA_FLOW_PER_100000
,   SUM(NUMBER_OF_MEASUREMENTS) as NUMBER_OF_MEASUREMENTS
,   count(*) AS NUMBER_OF_LOCATIONS
,   CASE
        WHEN B.GEBIEDSCODE = 'VR08' AND WEEK_UNIX < 1601856000 THEN MAX(NUMBER_OF_RWZI)+2       -- Vanaf week van 5-10-2020 is RWZI Aalst (code 9029) opgeheven
        WHEN B.GEBIEDSCODE = 'VR08' AND WEEK_UNIX >= 1601856000 AND  WEEK_UNIX < 1607299200
            THEN MAX(NUMBER_OF_RWZI)+1                                                          -- Vanaf week van 7-12-2020 is RWZI Lienden (code 9043) opgeheven
        ELSE MAX(NUMBER_OF_RWZI)                                                                -- Number of 2021
     END AS TOTAL_NUMBER_OF_LOCATIONS
FROM BASE_CTE  B
-- Add Total number of locations
LEFT JOIN (
    SELECT [GEBIEDSCODE]
      ,count(*) AS NUMBER_OF_RWZI
    FROM [VWSSTATIC].[RWZI_INHIBITANTS_2021]
    WHERE GEBIEDSCODE like 'VR%'
    AND DATE_LAST_INSERTED = (select max(DATE_LAST_INSERTED) from [VWSSTATIC].[RWZI_INHIBITANTS_2021])
    AND PERCENTAGE != 0
    GROUP BY GEBIEDSCODE
) C
ON B.GEBIEDSCODE = C.GEBIEDSCODE
group by WEEK_UNIX, B.GEBIEDSCODE
END