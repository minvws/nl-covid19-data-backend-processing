-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_HOSPITAL_ADMISSIONS_NICE
AS
BEGIN
-- Move hospital admission NICE data from intermediate table to destination table. 
-- Main select and insert statement for hospital admissions. Moving average is set to look back 2 days. This can be altered in line 11, after the BETWEEN function.
    INSERT INTO VWSDEST.HOSPITAL_ADMISSIONS_NICE
    (
        DATE_OF_REPORT,
        DATE_OF_REPORT_UNIX,
        TOTAL_COUNTS_PER_DAY,
        MOVING_AVERAGE_HOSPITAL
    )
    SELECT
            [DATE] AS DATE_OF_REPORT
        ,   dbo.CONVERT_DATETIME_TO_UNIX( [DATE]) AS [DATE_OF_REPORT_UNIX]
        ,   [VALUE] AS [TOTAL_COUNTS_PER_DAY]
            -- t(0) = ( t(-1) + t(-2) + t(-3) ) / 3
        ,   ROUND(AVG(CAST(VALUE AS FLOAT)) OVER (ORDER BY [DATE] ASC ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING),1) AS [MOVING_AVERAGE_HOSPITAL]
    FROM VWSINTER.NICE_HOSPITAL_ADMISSIONS_NATIONAL
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.NICE_HOSPITAL_ADMISSIONS_NATIONAL)
END;