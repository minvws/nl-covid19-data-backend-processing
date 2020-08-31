-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE [dbo].[SP_SEWER_MEASUREMENTS_PER_MUNICIPALITY]
AS
BEGIN
-- Move sewer measurement per region data from intermediate to production table.
WITH BASE_CTE AS (
    SELECT 
            DATEPART(wk, DATE_MEASUREMENT) as [WEEKNUMBER]
        ,   dbo.CONVERT_WEEKNUMBER_TO_UNIX(DATEPART(wk, DATE_MEASUREMENT)) as [WEEK_UNIX]
        ,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_MEASUREMENT) AS [DATE_MEASUREMENT_UNIX]
        ,   RNA_PER_ML
        ,   Percentage_in_security_region
        ,   Security_region_code
        ,   RWZI_AWZI_code
    FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS]
    WHERE REPRESENTATIVE_MEASUREMENT = 1
        AND TRIM(UPPER(RWZI_AWZI_name)) != 'SCHIPHOL'
        AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS])
)
-- Appoint the RWZI location to the security region with the highest percentage.
, SECOND_CTE AS (
    SELECT 
            T1.WEEKNUMBER
        ,   T1.WEEK_UNIX
        ,   T1.DATE_MEASUREMENT_UNIX
        ,   T1.RNA_PER_ML
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
            WEEKNUMBER AS WEEK
        ,   WEEK_UNIX
        ,   RWZI_AWZI_code
        ,   GMCODE
        ,   SUM(RNA_PER_ML) AS SUM_RNA_PER_ML
    FROM SECOND_CTE
    GROUP BY WEEKNUMBER, WEEK_UNIX, RWZI_AWZI_code, GMCODE
)
-- Insert the rows into the destionation table
INSERT INTO VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY (
        WEEK
    ,   WEEK_UNIX
    ,   GMCODE
    ,   AVERAGE)
SELECT
        WEEK
    ,   WEEK_UNIX
    ,   GMCODE
    ,   ROUND(AVG(CAST(SUM_RNA_PER_ML AS DECIMAL)),2) as AVERAGE_RNA_PER_GM
FROM THIRD_CTE
GROUP BY WEEK, WEEK_UNIX, GMCODE;

END;
GO