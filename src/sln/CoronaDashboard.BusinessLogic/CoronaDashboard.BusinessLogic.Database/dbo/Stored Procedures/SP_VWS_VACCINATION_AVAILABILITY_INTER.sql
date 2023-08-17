-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE [dbo].[SP_VWS_VACCINATION_AVAILABILITY_INTER]
AS
BEGIN
    INSERT INTO VWSINTER.VWS_VACCINATION_AVAILABILITY (
        [VALID_FROM],
        [VACCIN_NAME],
        [EXPECTED_OR_OPTIONS],
        [DATE_DELIVERY],
        [AMOUNT_DELIVERY]
    )
    SELECT
        -- Datetime format in source file is dd-mm-yyyy
        CONVERT(DATETIME, VALID_FROM, 105) AS VALID_FROM,
        VACCIN_NAME,
        EXPECTED_OR_OPTIONS,
        CONVERT(DATETIME, DATE_DELIVERY, 105) AS DATE_DELIVERY,
        CONVERT(FLOAT, AMOUNT_DELIVERY) AS AMOUNT_DELIVERY
    FROM 
        VWSSTAGE.VWS_VACCINATION_AVAILABILITY
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                                  FROM VWSSTAGE.VWS_VACCINATION_AVAILABILITY)
END;