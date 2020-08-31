-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE dbo.SP_INTENSIVE_CARE_ADMISSIONS
AS
BEGIN
-- Main select and insert statement for IC. Moving average is set to look back 3 days. This can be altered in line 12, after the BETWEEN function.
-- Move IC data from intermediate table to destination table. 
    INSERT INTO VWSDEST.INTENSIVE_CARE_ADMISSIONS
    (DATE_OF_REPORT, DATE_OF_REPORT_UNIX, MOVING_AVERAGE_IC)
    SELECT
        DATE_OF_REPORT
    ,   dbo.CONVERT_DATETIME_TO_UNIX( DATE_OF_REPORT) AS DATE_OF_REPORT_UNIX
    ,   ROUND(AVG(CAST(SOMMAGE AS FLOAT)) OVER (ORDER BY DATE_OF_REPORT ASC ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING),1) AS MOVING_AVERAGE_IC
    FROM(
		SELECT
			DATE_OF_REPORT
		,   SUM(VALUE) AS SOMMAGE
		FROM VWSINTER.FOUNDATION_NICE_IC_INTAKE_COUNT
		WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.FOUNDATION_NICE_IC_INTAKE_COUNT)
		GROUP BY DATE_OF_REPORT
	) AS SubqueryA
END;