-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move sewer measurements data from staging to intermediate table.

-- Comments:
-- 1. Either RNA_PER_ML or RNA_FLOW_PER_100000 is filled. The other is empty: RNA_PER_ML seems legacy
-- 2. RNA_FLOW_PER_100000 can be either empty or 0. Records with no values are left out (RNA_PER_ML was measured)

CREATE OR ALTER PROCEDURE [dbo].[SP_RIVM_SEWER_MEASUREMENTS_INTER]
AS
BEGIN
    INSERT INTO VWSINTER.RIVM_SEWER_MEASUREMENTS (
            DATE_MEASUREMENT
        ,   Version
        ,   RWZI_AWZI_CODE
        ,   RWZI_AWZI_NAME
        ,   RNA_PER_ML
        ,   RNA_FLOW_PER_100000)
    SELECT 
            CONVERT(DATETIME, DATE_MEASUREMENT,126) AS DATE_MEASUREMENT
        ,   VERSION
        ,   RWZI_AWZI_CODE
        ,   RWZI_AWZI_NAME
        ,   CAST((SELECT CONVERT(FLOAT, ISNULL(NULLIF(RNA_PER_ML, ''), '0'))) AS BIGINT) as RNA_PER_ML
        ,   CONVERT(BIGINT, CONVERT(FLOAT, REPLACE(RNA_FLOW_PER_100000,',','.'))) AS RNA_FLOW_PER_100000
    FROM 
       VWSSTAGE.RIVM_SEWER_MEASUREMENTS
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.RIVM_SEWER_MEASUREMENTS)
        AND RNA_FLOW_PER_100000 != ''
END;