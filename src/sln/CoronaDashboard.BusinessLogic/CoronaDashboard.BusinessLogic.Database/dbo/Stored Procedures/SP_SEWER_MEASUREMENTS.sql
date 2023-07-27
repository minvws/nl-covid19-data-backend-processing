
-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move sewer measurements data from intermediate to production table.
CREATE   PROCEDURE [dbo].[SP_SEWER_MEASUREMENTS]
AS
BEGIN
    -- Set week to start at Monday instead of Sunday
    SET DATEFIRST 1;

    -- Only take rows into account which are representative measurements and remove the rows from plant 'Schiphol'.
    WITH BASE_CTE AS (
    SELECT
            DATEPART(wk, DATE_MEASUREMENT) as [WEEK]
        ,   dbo.CONVERT_DATETIME_TO_UNIX(DATEADD(week, DATEDIFF(week, 0, DATE_MEASUREMENT - 1), 0)) as [WEEK_UNIX]
        ,   DATE_MEASUREMENT
        ,	RNA_PER_ML
        ,   RWZI_AWZI_CODE
        ,   PERCENTAGE_IN_SECURITY_REGION
        ,   1 AS [NUMBER_OF_MEASUREMENTS]
        ,   RNA_FLOW_PER_100000
        FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS_ARCHIVE]
        WHERE REPRESENTATIVE_MEASUREMENT = 1
        AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS])
        AND TRIM(UPPER(RWZI_AWZI_name)) != 'SCHIPHOL'
    )

    -- Only take the rows into account per sewer treatment plant and measurement-date which have the highest percentage_in_security_region to make sure plants are not taken into account twice.
    , MIDDLE_CTE AS (
    SELECT distinct *
        FROM (
            SELECT 
                *
                ,   RANK() OVER(PARTITION BY DATE_MEASUREMENT, RWZI_AWZI_code ORDER BY PERCENTAGE_IN_SECURITY_REGION DESC) rn
            FROM BASE_CTE T1
        ) T2
        WHERE T2.rn = 1
    )
    INSERT INTO VWSDEST.SEWER_MEASUREMENTS_ARCHIVE
            ([WEEK_UNIX],
            [AVERAGE],
            [AVERAGE_RNA_FLOW_PER_100000],
            [NUMBER_OF_MEASUREMENTS],
            [NUMBER_OF_LOCATIONS])
    SELECT
            WEEK_UNIX
        ,   CAST(ROUND(AVG(CAST(RNA_PER_ML AS DECIMAL)),2) AS DECIMAL(16,2)) AS AVERAGE
        ,   CAST(ROUND(AVG(CAST(RNA_FLOW_PER_100000 AS DECIMAL)) / 1.0E+11 ,2) AS DECIMAL(16,2)) AS RNA_FLOW_PER_100000
        ,   SUM(NUMBER_OF_MEASUREMENTS) AS NUMBER_OF_MEASUREMENTS
        ,   count(distinct RWZI_AWZI_CODE) as NUMBER_OF_INSTALLATIONS
    FROM MIDDLE_CTE
    GROUP BY WEEK, WEEK_UNIX

END;