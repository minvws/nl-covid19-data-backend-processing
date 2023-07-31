-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE [dbo].[SP_VWS_VACCINE_ADMINISTERED_TEMP]
AS
BEGIN
    INSERT INTO VWSINTER.VACCINE_ADMINISTERED_TEMP (
        [DATE_OF_REPORT],
        [DATE_OF_STATISTIC],
        [TARGET_GROUP],
        [SUB_TARGET_GROUP],
        [VACCINATION_NAME],
        [SHOT_ROUND],
        [VACCINATIONS_AMOUNT],
        [SOURCE],
        [REPORT_STATUS]        
    )

    SELECT
        -- Datetime format in source file is dd-mm-yyyy
        CONVERT(DATE, DATE_OF_REPORT, 105)                      AS DATE_OF_REPORT,
        CONVERT(DATE, DATE_OF_STATISTIC, 105)                   AS DATE_OF_STATISTIC,
        [TARGET_GROUP],
        [SUB_TARGET_GROUP],
        [VACCINATION_NAME],
        [SHOT_ROUND],
        CONVERT(INT, [VACCINATIONS_AMOUNT])                     AS VACCINATIONS_AMOUNT,
        CASE WHEN SOURCE = 'overig' THEN 'instellingen_zkh'
            ELSE SOURCE
            END AS [SOURCE],
        [REPORT_STATUS]
    FROM 
        VWSSTAGE.VACCINE_ADMINISTERED_TEMP
    WHERE 
        DATE_LAST_INSERTED = (
            SELECT MAX(DATE_LAST_INSERTED)                                  
            FROM VWSSTAGE.VACCINE_ADMINISTERED_TEMP
            )
END;