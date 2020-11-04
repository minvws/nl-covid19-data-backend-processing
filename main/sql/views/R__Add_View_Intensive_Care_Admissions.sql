-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Create view for pulling intensive care admissions
CREATE OR ALTER VIEW VWSDEST.V_INTENSIVE_CARE_ADMISSIONS AS
SELECT
    [DATE_OF_REPORT_UNIX],
	DBO.NO_NEGATIVE_NUMBER_F([MOVING_AVERAGE_IC]) AS MOVING_AVERAGE_IC,
    dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.INTENSIVE_CARE_ADMISSIONS 
WHERE DATE_OF_REPORT >=  '2020-03-02 00:00:00.000'
AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM VWSDEST.INTENSIVE_CARE_ADMISSIONS);