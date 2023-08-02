

-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE [dbo].[SP_SEWER_MEASUREMENTS_PER_MUNICIPALITY]
AS
BEGIN
    -- Set week to start at Monday instead of Sunday
    SET DATEFIRST 1;

-- Move sewer measurement per region data from intermediate to production table.
WITH BASE_CTE AS (
    SELECT 
            DATEPART(wk, DATE_MEASUREMENT) as [WEEKNUMBER]
        ,   dbo.CONVERT_DATETIME_TO_UNIX(DATEADD(week, DATEDIFF(week, 0, DATE_MEASUREMENT - 1), 0)) as [WEEK_UNIX]
        ,   DATEDIFF(SECOND,{d '1970-01-01'}, CONVERT(DATETIME, DATE_MEASUREMENT, 101)) AS [DATE_MEASUREMENT_UNIX]
        ,   RNA_PER_ML
        ,   RNA_FLOW_PER_100000
        ,   Percentage_in_security_region
        ,   Security_region_code
        ,   RWZI_AWZI_code
    FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS_ARCHIVE]
    WHERE REPRESENTATIVE_MEASUREMENT = 1
        AND TRIM(UPPER(RWZI_AWZI_name)) != 'SCHIPHOL'
        AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS])
)
-- Appoint the RWZI location to the security region with the highest percentage.
, SECOND_CTE AS (
    SELECT DISTINCT
            T1.WEEKNUMBER
        ,   T1.WEEK_UNIX
        ,   T1.DATE_MEASUREMENT_UNIX
        ,   T1.RNA_PER_ML
        ,   T1.RNA_FLOW_PER_100000
        ,   T1.Percentage_in_security_region
        ,   T1.Security_region_code
        ,   T1.RWZI_AWZI_code
        ,   T3.GM_CODE AS GMCODE
    from BASE_CTE as T1
    INNER JOIN 
    (
        SELECT 
                DATE_MEASUREMENT_UNIX
            ,   RWZI_AWZI_code
            ,   MAX(Percentage_in_security_region) as maximum_value
        FROM BASE_CTE
        GROUP BY RWZI_AWZI_code, DATE_MEASUREMENT_UNIX
    ) AS T2
        ON T1.Percentage_in_security_region = T2.maximum_value 
            AND T1.DATE_MEASUREMENT_UNIX = T2.DATE_MEASUREMENT_UNIX
            AND T1.RWZI_AWZI_code = T2.RWZI_AWZI_code
    LEFT JOIN VWSSTATIC.RWZI_GMCODE T3
    ON T1.RWZI_AWZI_code = T3.RWZI_CODE
)

-- Group by week and municipality and calculate the average of the region
, THIRD_CTE AS (
    SELECT
            WEEKNUMBER
        ,   WEEK_UNIX
        ,   RWZI_AWZI_code
        ,   GMCODE
        ,   SUM(RNA_PER_ML) AS SUM_RNA_PER_ML
        ,   SUM(RNA_FLOW_PER_100000) AS SUM_RNA_FLOW_PER_100000
    FROM SECOND_CTE
    GROUP BY WEEKNUMBER, WEEK_UNIX, RWZI_AWZI_code, GMCODE
)


, FOURTH_CTE AS (
    SELECT WEEKNUMBER
        ,   WEEK_UNIX
        ,   RWZI_AWZI_code
        ,   GMCODE
        ,   SUM(NUMBER_OF_RECORDS) AS NUMBER_OF_RECORDS
    FROM (
    SELECT
            WEEKNUMBER
        ,   WEEK_UNIX
        ,   RWZI_AWZI_code
        ,   GMCODE
        ,   COUNT(*) as NUMBER_OF_RECORDS
    FROM SECOND_CTE T1
    GROUP BY WEEKNUMBER, WEEK_UNIX, RWZI_AWZI_code, GMCODE, RNA_PER_ML) T1
    GROUP BY WEEKNUMBER
        ,   WEEK_UNIX
        ,   RWZI_AWZI_code
        ,   GMCODE
)

-- Insert the rows into the destionation table
INSERT INTO VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY_ARCHIVE (
        WEEK_UNIX
    ,   GMCODE
    ,   AVERAGE
    ,   AVERAGE_RNA_FLOW_PER_100000
    ,   NUMBER_OF_MEASUREMENTS
    ,   NUMBER_OF_LOCATIONS)
SELECT
        T1.WEEK_UNIX
    ,   T1.GMCODE
    ,   ROUND(AVG((CAST(SUM_RNA_PER_ML AS DECIMAL)/T2.NUMBER_OF_RECORDS)),2) as AVERAGE_RNA_PER_GM
    ,   ROUND(AVG((CAST(SUM_RNA_FLOW_PER_100000 AS DECIMAL)/T2.NUMBER_OF_RECORDS))  / 1.0E+11, 2) as RNA_FLOW_PER_100000
    ,   COUNT(T1.RWZI_AWZI_code)    -- Currently unused, due to time pressure not 100% checked 
    ,   COUNT(DISTINCT T1.RWZI_AWZI_code)
FROM THIRD_CTE T1
JOIN FOURTH_CTE T2
    ON T1.WEEKNUMBER = T2.WEEKNUMBER
    AND T1.GMCODE = T2.GMCODE
GROUP BY T1.WEEK_UNIX, T1.WEEKNUMBER, T1.GMCODE


END;