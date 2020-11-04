-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_HOSPITAL_ADMISSIONS
AS
BEGIN
-- Move hospital intake data from intermediate table to destination table. 
-- Main select and insert statement for hospital admissions. Moving average is set to look back 2 days. This can be altered in line 11, after the BETWEEN function.
    INSERT INTO VWSDEST.HOSPITAL_ADMISSIONS
    (DATE_OF_REPORT, DATE_OF_REPORT_UNIX, TOTAL_COUNTS_PER_DAY, MOVING_AVERAGE_HOSPITAL)
    SELECT
		DATE_OF_REPORT
    ,   dbo.CONVERT_DATETIME_TO_UNIX( DATE_OF_REPORT) AS [DATE_OF_REPORT_UNIX]
    ,   [TOTAL_COUNTS_PER_DAY]
    ,   ROUND(AVG(CAST(TOTAL_COUNTS_PER_DAY AS FLOAT)) OVER (ORDER BY DATE_OF_REPORT ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),1) AS [MOVING_AVERAGE_HOSPITAL]
    FROM(
			-- Sub select ; needed to calculate hospital admission per day
            SELECT
                DATE_OF_PUBLICATION AS DATE_OF_REPORT
            ,   SUM(CAST(HOSPITAL_ADMISSION AS FLOAT)) AS [TOTAL_COUNTS_PER_DAY]
            FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY
            WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY)
            GROUP BY DATE_OF_PUBLICATION
    ) AS SubqueryA
END;