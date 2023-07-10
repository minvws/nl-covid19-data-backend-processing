-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move data Reproduction number data from intermediate to production table.
CREATE   PROCEDURE DBO.SP_REPRODUCTION_NUMBER
AS
BEGIN
    INSERT INTO VWSDEST.REPRODUCTION_NUMBER
        (DATE_OF_REPORT,
        DATE_OF_REPORT_UNIX,
        REPRODUCTION_INDEX_LOW,
        REPRODUCTION_INDEX_AVG,
        REPRODUCTION_INDEX_HIGH )
    SELECT
        [DATE],
        dbo.CONVERT_DATETIME_TO_UNIX([DATE]) AS DATE_OF_REPORT_UNIX,
        RT_LOW AS REPRODUCTION_INDEX_LOW,
        RT_AVG AS REPRODUCTION_INDEX_AVG,
        RT_UP AS REPRODUCTION_INDEX_HIGH
    FROM
       VWSINTER.RIVM_REPRODUCTION_NUMBER
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSINTER.RIVM_REPRODUCTION_NUMBER)
END;