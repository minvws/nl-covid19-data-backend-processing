-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_RIVM_INFECTIOUS_PEOPLE_INTER
AS
BEGIN
-- Main select and insert into statement. Filtered values on max datelastinserted.
-- Move infectious data from staging to intermediate table. 
    INSERT INTO VWSINTER.RIVM_INFECTIOUS_PEOPLE
        ([DATE]
     ,   prev_low
     ,   prev_avg
     ,   prev_up )
    SELECT
        [DATE]
    ,    (CASE WHEN PREV_LOW = '' THEN NULL ELSE PREV_LOW END) AS PREV_LOW
    ,    (CASE WHEN PREV_AVG = '' THEN NULL ELSE PREV_AVG END) AS PREV_AVG
    ,    (CASE WHEN PREV_UP = '' THEN NULL ELSE PREV_UP END) AS PREV_UP
    FROM VWSSTAGE.RIVM_INFECTIOUS_PEOPLE
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.RIVM_INFECTIOUS_PEOPLE)
END;
