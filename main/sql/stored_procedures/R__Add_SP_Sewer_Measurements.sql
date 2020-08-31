-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move sewer measurements data from intermediate to production table.
CREATE OR ALTER PROCEDURE [dbo].[SP_SEWER_MEASUREMENTS]
AS
BEGIN
    -- Only take rows into account which are representative measurements and remove the rows from plant 'Schiphol'.
    WITH BASE_CTE AS (
    SELECT
            DATEPART(wk, DATE_MEASUREMENT) as [WEEK]
        ,   dbo.CONVERT_WEEKNUMBER_TO_UNIX(DATEPART(wk, DATE_MEASUREMENT)) as [WEEK_UNIX]
        ,   DATE_MEASUREMENT
        ,	RNA_PER_ML
        ,   RWZI_AWZI_CODE
        ,   PERCENTAGE_IN_SECURITY_REGION
        ,   1 AS [NUMBER_OF_INSTALLATIONS]
        FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS]
        WHERE REPRESENTATIVE_MEASUREMENT = 1
        AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS])
        AND TRIM(UPPER(RWZI_AWZI_name)) != 'SCHIPHOL'
    )

    -- Only take the rows into account per sewer treatment plant and measurement-date which have the highest percentage_in_security_region to make sure plants are not taken into account twice.
    , MIDDLE_CTE AS (
    SELECT *
        FROM (
            SELECT 
                *
                ,   RANK() OVER(PARTITION BY DATE_MEASUREMENT, RWZI_AWZI_code ORDER BY PERCENTAGE_IN_SECURITY_REGION DESC) rn
            FROM BASE_CTE T1
        ) T2
        WHERE T2.rn = 1
    )

    INSERT INTO VWSDEST.SEWER_MEASUREMENTS
            ([WEEK],
            [WEEK_UNIX],
            [AVERAGE],
            [NUMBER_OF_MEASUREMENTS])
    SELECT
            WEEK
        ,   WEEK_UNIX
        ,   CAST(ROUND(AVG(CAST(RNA_PER_ML AS DECIMAL)),2) AS DECIMAL(16,2)) AS AVERAGE
        ,   count(NUMBER_OF_INSTALLATIONS) as NUMBER_OF_MEASUREMENTS
    FROM MIDDLE_CTE
    GROUP BY WEEK, WEEK_UNIX

END;