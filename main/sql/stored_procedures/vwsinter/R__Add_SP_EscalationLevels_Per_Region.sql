-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_ESCALATIONLEVELS_PER_REGION
AS
BEGIN
    INSERT INTO VWSDEST.ESCALATIONLEVELS_PER_REGION
    (DATE_OF_REPORT,
        DATE_OF_REPORT_UNIX,
        VRCODE,
        ESCALATION_LEVEL,
        DATE_OF_START_VALIDITY,
        DATE_OF_END_VALIDITY
        )
    SELECT
        DATE_LAST_INSERTED as DATE_OF_REPORT,
        dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_REPORT_UNIX,
        Veiligheidsregio_code,
        [CORONANIVEAU_CODE],
        case
            when Geldig_vanaf_datum is NOT NULL and Geldig_vanaf_datum != '' then CONVERT(DATETIME, Geldig_vanaf_datum, 103)
            ELSE NULL
        END AS DATE_OF_START_VALIDITY,
        case
            when Geldig_tm_datum is NOT NULL and Geldig_tm_datum != '' then CONVERT(DATETIME, Geldig_tm_datum, 103)
            ELSE NULL
        END AS DATE_OF_END_VALIDITY
    FROM 
       VWSSTAGE.VWS_CORONALEVEL_REGIONS
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                                  FROM VWSSTAGE.VWS_CORONALEVEL_REGIONS)
END;
