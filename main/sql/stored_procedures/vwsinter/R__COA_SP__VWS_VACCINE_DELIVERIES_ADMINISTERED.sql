-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE [dbo].[SP_VWS_VACCINE_DELIVERIES_ADMINISTERED_INTER]
AS
BEGIN
    INSERT INTO VWSINTER.VWS_VACCINE_DELIVERIES_ADMINISTERED (
    DATE_OF_REPORT ,
    DATE_FIRST_DAY ,
    VALUE_TYPE ,
    VALUE_NAME ,
    REPORT_STATUS,
    [VALUE] 
    )
    SELECT
        -- Datetime format in source file is dd-mm-yyyy

    CONVERT(DATETIME,DATE_OF_REPORT, 105) AS DATE_OF_REPORT,
    CONVERT(DATETIME,DATE_FIRST_DAY, 105) AS DATE_FIRST_DAY,
    VALUE_TYPE ,
    VALUE_NAME ,
    REPORT_STATUS,
    CAST([VALUE] AS BIGINT) AS [VALUE]

    FROM 
        VWSSTAGE.VWS_VACCINE_DELIVERIES_ADMINISTERED
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                                  FROM VWSSTAGE.VWS_VACCINE_DELIVERIES_ADMINISTERED)
END;
