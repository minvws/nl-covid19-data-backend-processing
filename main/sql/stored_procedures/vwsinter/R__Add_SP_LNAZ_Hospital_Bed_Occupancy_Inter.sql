-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move national data from staging to intermediate table.
CREATE OR ALTER PROCEDURE dbo.SP_LNAZ_HOSPITAL_BED_OCCUPANCY_INTER
AS
BEGIN
    INSERT INTO VWSINTER.LNAZ_HOSPITAL_BED_OCCUPANCY
        (   [DATUM],
            [IC_BEDDEN_COVID],
            [IC_BEDDEN_NON_COVID],
            [KLINIEK_BEDDEN]
        )
    SELECT
    --- conversion of date in dd-mm-yyyy format ---
        CONVERT(DATETIME, [DATUM], 105),
        TRIM([IC_BEDDEN_COVID]),
        TRIM([IC_BEDDEN_NON_COVID]),
        TRIM([KLINIEK_BEDDEN])
    FROM
       VWSSTAGE.LNAZ_HOSPITAL_BED_OCCUPANCY
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.LNAZ_HOSPITAL_BED_OCCUPANCY)
END;
