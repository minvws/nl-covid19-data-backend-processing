-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
CREATE OR ALTER PROCEDURE [dbo].[SP_SEWER_BASE]
AS
BEGIN
INSERT INTO VWSDEST.SEWER_BASE
        (
            WEEK,
            WEEK_UNIX,
            DATE_MEASUREMENT,
            RWZI_AWZI_CODE,
            RWZI_AWZI_NAME,
            RNA_PER_ML,
            RNA_FLOW_PER_100000,
            COUNT_DAILY_MEASUREMENT
        )
SELECT
        DATEPART(ISO_WEEK, T1.DATE_MEASUREMENT) as WEEK
    ,   dbo.CONVERT_DATETIME_TO_UNIX(DATEADD(week, DATEDIFF(week, 0, T1.DATE_MEASUREMENT - 1), 0)) as WEEK_UNIX
    ,   T1.DATE_MEASUREMENT
    ,   T1.RWZI_AWZI_CODE
    ,   T1.RWZI_AWZI_NAME
    ,   T1.RNA_PER_ML
    ,   T1.RNA_FLOW_PER_100000
    -- So first occurence of a DATE_MEASUREMENT, RWZI_AWZI_CODE gets a 1, second 2.
    -- We do this because we filter on this later
    ,   ROW_NUMBER() OVER (PARTITION BY DATE_MEASUREMENT, RWZI_AWZI_CODE ORDER BY DATE_MEASUREMENT, RWZI_AWZI_CODE) as COUNT_DAILY_MEASUREMENT

FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS] as T1
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS])
AND TRIM(UPPER(RWZI_AWZI_name)) != 'SCHIPHOL' 
END