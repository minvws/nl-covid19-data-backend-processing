-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE DBO.SP_INFECTIOUS_PEOPLE
AS
BEGIN
-- Move data from intermediate table to destination table
--Normalization variable that is used in the second select and insert into statement.
    DECLARE @NORMALIZATION FLOAT;
    SET @NORMALIZATION = 17407585.0/100000.0;

-- Select and insert statement for infectious persons. Filter on last datelastinserted to get the latest record.
    INSERT INTO VWSDEST.INFECTIOUS_PEOPLE
        (DATE_OF_REPORT
    ,   DATE_OF_REPORT_UNIX
    ,   INFECTIOUS_LOW
    ,   INFECTIOUS_AVG
    ,   INFECTIOUS_HIGH
    ,   INFECTIOUS_LOW_NORMALIZED
    ,   INFECTIOUS_AVG_NORMALIZED
    ,   INFECTIOUS_HIGH_NORMALIZED)
    SELECT
        [DATE]
    ,   dbo.CONVERT_DATETIME_TO_UNIX([DATE]) AS DATE_OF_REPORT_UNIX
    ,   PREV_LOW AS INFECTIOUS_LOW
    ,   PREV_AVG AS INFECTIOUS_AVG
    ,   PREV_UP	 AS INFECTIOUS_HIGH
    ,   ROUND(CAST(PREV_LOW AS FLOAT)/(@NORMALIZATION),1) AS INFECTIOUS_LOW_NORMALIZED
    ,   ROUND(CAST(PREV_AVG AS FLOAT)/(@NORMALIZATION),1) AS INFECTIOUS_AVG_NORMALIZED
    ,   ROUND(CAST(PREV_UP	AS FLOAT)/(@NORMALIZATION),1) AS INFECTIOUS_HIGH_NORMALIZED
    FROM  VWSINTER.RIVM_INFECTIOUS_PEOPLE
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.RIVM_INFECTIOUS_PEOPLE)

END;