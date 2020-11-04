-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move sewer measurements data per sewer treatment plant from intermediate to production table.
CREATE OR ALTER PROCEDURE [dbo].[SP_SEWER_MEASUREMENTS_PER_RWZI]
AS
BEGIN

-- Only take rows into account which are representative measurements and remove the rows from plant 'Schiphol'.
WITH BASE_CTE AS (
    SELECT
            DATEPART(wk, DATE_MEASUREMENT) as [WEEK]
        ,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_MEASUREMENT) AS [DATE_MEASUREMENT_UNIX]
        ,   DATE_MEASUREMENT
        ,	RNA_PER_ML
        ,   CAST(RNA_FLOW_PER_100000 / 1.0E+11 AS DECIMAL(16,2)) AS RNA_FLOW_PER_100000
        ,   RWZI_AWZI_CODE
        ,   SECURITY_REGION_CODE
        ,   PERCENTAGE_IN_SECURITY_REGION
    FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS]
    WHERE REPRESENTATIVE_MEASUREMENT = 1
    AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS])
    AND TRIM(UPPER(RWZI_AWZI_name)) != 'SCHIPHOL'
)

-- Only take the rows into account per sewer treatment plant and measurement-date which have the highest percentage_in_security_region to make sure plants are not taken into account twice.
, MIDDLE_CTE AS (
    SELECT
            T1.WEEK
        ,   T1.DATE_MEASUREMENT
        ,   T1.DATE_MEASUREMENT_UNIX
        ,   T1.RNA_PER_ML
        ,   T1.RNA_FLOW_PER_100000
        ,   T1.SECURITY_REGION_CODE
        ,   T1.PERCENTAGE_IN_SECURITY_REGION
        ,   T1.RWZI_AWZI_code
    FROM BASE_CTE T1
    INNER JOIN (
        SELECT
                RWZI_AWZI_CODE
            ,   DATE_MEASUREMENT_UNIX
            ,   MAX(PERCENTAGE_IN_SECURITY_REGION) AS [MAX_PERCENTAGE]
        FROM BASE_CTE
        GROUP BY RWZI_AWZI_code, DATE_MEASUREMENT_UNIX
    ) T2
        ON T1.RWZI_AWZI_CODE = T2.RWZI_AWZI_CODE
            AND T1.PERCENTAGE_IN_SECURITY_REGION = T2.MAX_PERCENTAGE
            AND T1.DATE_MEASUREMENT_UNIX = T2.DATE_MEASUREMENT_UNIX
)

-- Combine with static data to link region-names and plant-names.
, FINAL_CTE AS (
    SELECT
        T1.RWZI_AWZI_CODE
    ,   T2.RWZI_AWZI_NAME
    ,   T1.SECURITY_REGION_CODE
    ,   T1.DATE_MEASUREMENT
    ,   T1.RNA_PER_ML
    ,   T1.RNA_FLOW_PER_100000
    ,   T1.WEEK
    ,   T1.DATE_MEASUREMENT_UNIX
    ,   T3.VRCODE
    ,   T3.VRNAAM
    FROM MIDDLE_CTE T1
    LEFT JOIN [VWSSTATIC].[RWZI_AWZI]	T2	ON T1.RWZI_AWZI_CODE	= T2.RWZI_AWZI_CODE
    LEFT JOIN (SELECT DISTINCT VRCODE, VRNAAM FROM [VWSSTATIC].[SAFETY_REGIONS_PER_MUNICIPAL])	T3	ON T1.SECURITY_REGION_CODE	= T3.VRCODE
)

INSERT INTO VWSDEST.SEWER_MEASUREMENTS_PER_RWZI
    (   [DATE_MEASUREMENT]
    ,   [DATE_MEASUREMENT_UNIX]
    ,   [WEEK]
    ,   [RWZI_AWZI_CODE]
    ,   [RWZI_AWZI_NAME]
    ,   [VRCODE]
    ,   [VRNAAM]
    ,   [RNA_PER_ML]
    ,   [RNA_FLOW_PER_100000]
    )
SELECT
        [DATE_MEASUREMENT]
    ,   [DATE_MEASUREMENT_UNIX]
    ,   [WEEK]
    ,   [RWZI_AWZI_CODE]
    ,   [RWZI_AWZI_NAME]
    ,   [VRCODE]
    ,   [VRNAAM]
    ,   [RNA_PER_ML]
    ,   [RNA_FLOW_PER_100000]
    FROM FINAL_CTE


END;
GO





