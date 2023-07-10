
-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move sewer measurement per region data from intermediate to production table.
CREATE   PROCEDURE [dbo].[SP_SEWER_MEASUREMENTS_PER_REGION]
AS
BEGIN
-- Set week to start at Monday instead of Sunday
SET DATEFIRST 1;

-- Select the required information for the intermediate table for calculation region data from sewers
WITH BASE_CTE AS (
    SELECT 
            DATEPART(wk, DATE_MEASUREMENT) as [WEEKNUMBER]
        -- Get the Monday of the given date and calculate a unix timestamp of that monday
        ,   dbo.CONVERT_DATETIME_TO_UNIX(DATEADD(week, DATEDIFF(week, 0, DATE_MEASUREMENT - 1), 0)) as [WEEK_UNIX]
        ,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_MEASUREMENT) AS [DATE_MEASUREMENT_UNIX]
        ,   RNA_PER_ML
        ,   Percentage_in_security_region
        ,   Security_region_code
        ,   RWZI_AWZI_code
        ,   RNA_FLOW_PER_100000
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
        ,   T1.Percentage_in_security_region
        ,   T1.Security_region_code
        ,   T1.RWZI_AWZI_code
        ,   T1.RNA_FLOW_PER_100000
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
)

-- Group by week and security region and calculate the average of the region
, THIRD_CTE AS (
    SELECT
            WEEKNUMBER AS WEEK
        ,   WEEK_UNIX
        ,   Security_region_code AS SECURITY_REGION_CODE
        ,   ROUND(AVG(CAST(RNA_PER_ML AS DECIMAL)),2) as AVERAGE_RNA_PER_REGION
        ,   ROUND(AVG(CAST(RNA_FLOW_PER_100000 AS DECIMAL) / 1.0E+11)  ,2) AS AVERAGE_RNA_FLOW_PER_100000
        ,   COUNT(*) AS NUMBER_OF_MEASUREMENTS
        ,   COUNT(DISTINCT RWZI_AWZI_code) AS NUMBER_OF_LOCATIONS
    FROM SECOND_CTE
    GROUP BY  WEEK_UNIX, WEEKNUMBER, Security_region_code
)
-- Insert the rows into the destionation table
INSERT INTO VWSDEST.SEWER_MEASUREMENTS_PER_Region_ARCHIVE(
       WEEK_UNIX
    ,   VRCODE
    ,   AVERAGE
    ,   AVERAGE_RNA_FLOW_PER_100000
    ,   NUMBER_OF_MEASUREMENTS
    ,   NUMBER_OF_LOCATIONS)
SELECT
        WEEK_UNIX
    ,   SECURITY_REGION_CODE
    ,   AVERAGE_RNA_PER_REGION
    ,   AVERAGE_RNA_FLOW_PER_100000
    ,   NUMBER_OF_MEASUREMENTS
    ,   NUMBER_OF_LOCATIONS
from THIRD_CTE

END;