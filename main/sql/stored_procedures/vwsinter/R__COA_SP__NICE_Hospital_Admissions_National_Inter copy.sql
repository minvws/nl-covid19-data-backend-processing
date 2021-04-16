-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move data IC data from staging to intermediate table.
CREATE OR ALTER PROCEDURE DBO.SP_NICE_HOSPITAL_ADMISSIONS_NATIONAL_INTER
AS
BEGIN
    INSERT INTO VWSINTER.NICE_HOSPITAL_ADMISSIONS_NATIONAL
    (
        [DATE],
        [VALUE]
    )
    SELECT 
        [DATE], 
        [VALUE]
    FROM 
       VWSSTAGE.NICE_HOSPITAL_ADMISSIONS_NATIONAL
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                                  FROM VWSSTAGE.NICE_HOSPITAL_ADMISSIONS_NATIONAL)
END;