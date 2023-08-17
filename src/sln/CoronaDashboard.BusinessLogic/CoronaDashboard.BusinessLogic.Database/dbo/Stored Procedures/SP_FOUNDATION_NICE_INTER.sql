-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move data IC data from staging to intermediate table.
CREATE   PROCEDURE DBO.SP_FOUNDATION_NICE_INTER
AS
BEGIN
    INSERT INTO VWSINTER.FOUNDATION_NICE_IC_INTAKE_COUNT
    (DATE_OF_REPORT, [VALUE])
    SELECT 
        [DATE], 
        [VALUE]
    FROM 
       VWSSTAGE.FOUNDATION_NICE_IC_INTAKE_COUNT
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                                  FROM VWSSTAGE.FOUNDATION_NICE_IC_INTAKE_COUNT)
END;