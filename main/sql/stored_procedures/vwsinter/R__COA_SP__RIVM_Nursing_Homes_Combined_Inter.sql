-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_RIVM_NURSING_HOMES_COMBINED_INTER
AS
BEGIN
-- Main select and insert into statement. Filtered values on max datelastinserted.
-- Move nursery intake data from staging to intermediate table. 
    INSERT INTO VWSINTER.RIVM_NURSING_HOMES_COMBINED
    (
        [DATE_OF_REPORT],
        [DATE_OF_STATISTIC_REPORTED],
        [SECURITY_REGION_CODE],
        [SECURITY_REGION_NAME],
        [TOTAL_CASES_REPORTED],
        [TOTAL_DECEASED_REPORTED],
        [TOTAL_NEW_INFECTED_LOCATIONS_REPORTED],
        [TOTAL_INFECTED_LOCATIONS_REPORTED]
    )
    SELECT
        -- Provided datetime format in source file is yyyy-mm-dd
        CONVERT(DATETIME, [DATE_OF_REPORT], 102),
        CONVERT(DATETIME, [DATE_OF_STATISTIC_REPORTED], 102),
        TRIM([SECURITY_REGION_CODE]),
        [SECURITY_REGION_NAME],
        ISNULL(TOTAL_CASES_REPORTED,0) AS [TOTAL_CASES_REPORTED],
        ISNULL(TOTAL_DECEASED_REPORTED,0) AS [TOTAL_DECEASED_REPORTED],
        ISNULL(TOTAL_NEW_INFECTED_LOCATIONS_REPORTED,0) AS [TOTAL_NEW_INFECTED_LOCATIONS_REPORTED],
        ISNULL(TOTAL_INFECTED_LOCATIONS_REPORTED,0) AS [TOTAL_INFECTED_LOCATIONS_REPORTED]
    FROM VWSSTAGE.RIVM_NURSING_HOMES_COMBINED
        WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.RIVM_NURSING_HOMES_COMBINED)
END;

