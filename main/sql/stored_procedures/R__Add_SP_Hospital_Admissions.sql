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
        --Sub select; needed to determine difference per day
		SELECT
            DATE_OF_REPORT
        ,   HOSPITAL_ADMISSION - ISNULL(LAG(HOSPITAL_ADMISSION) OVER (ORDER BY DATE_OF_REPORT), 0) AS [TOTAL_COUNTS_PER_DAY]
        FROM(
			-- Sub select 2; needed to calculate hospital admission per day
            SELECT
                DATE_OF_REPORT
            ,   SUM(CAST(HOSPITAL_ADMISSION AS FLOAT)) AS [HOSPITAL_ADMISSION]
            FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE
            WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE)
            GROUP BY DATE_OF_REPORT
        ) AS SubqueryA
    ) AS SubqueryB
END;