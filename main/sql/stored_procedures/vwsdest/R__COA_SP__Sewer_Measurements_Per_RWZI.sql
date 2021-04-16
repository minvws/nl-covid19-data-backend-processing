-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

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
        ,   CAST(RNA_FLOW_PER_100000 / 1.0E+11 AS DECIMAL(16,2)) AS RNA_FLOW_PER_100000
        ,   RWZI_AWZI_CODE
    FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS]
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS])
    AND TRIM(UPPER(RWZI_AWZI_name)) != 'SCHIPHOL'
)
INSERT INTO VWSDEST.SEWER_MEASUREMENTS_PER_RWZI
    (   [DATE_MEASUREMENT]
    ,   [DATE_MEASUREMENT_UNIX]
    ,   [WEEK]
    ,   [RWZI_AWZI_CODE]
    ,   [RWZI_AWZI_NAME]
    ,   [RNA_FLOW_PER_100000]
    )
SELECT
        [DATE_MEASUREMENT]
    ,   [DATE_MEASUREMENT_UNIX]
    ,   [WEEK]
    ,   T1.[RWZI_AWZI_CODE]
    ,   [RWZI_AWZI_NAME]
    ,   [RNA_FLOW_PER_100000]
    FROM BASE_CTE T1
        LEFT JOIN [VWSSTATIC].[RWZI_AWZI]	T2	ON T1.RWZI_AWZI_CODE= T2.RWZI_AWZI_CODE
    AND T2.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.RWZI_AWZI )


END;
GO