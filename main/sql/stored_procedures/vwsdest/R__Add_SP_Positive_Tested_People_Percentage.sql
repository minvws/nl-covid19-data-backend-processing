-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_POSITIVE_TESTED_PEOPLE_PERCENTAGE
AS
BEGIN
    INSERT INTO VWSDEST.POSITIVE_TESTED_PEOPLE_PERCENTAGE
    (
        DATE_OF_REPORT,
        DATE_OF_REPORT_UNIX,
        INFECTED_GGD,
        PERCENTAGE_INFECTED_GGD,
        TOTAL_TESTED_GGD
    )
    SELECT
        [WEEK OF APPOINTMENT] AS DATE_OF_REPORT,
        dbo.CONVERT_DATETIME_TO_UNIX([WEEK OF APPOINTMENT]) AS DATE_OF_REPORT_UNIX,
        [TOTAL POSITIVE],
        [% POSITIVE],
        [TOTAL TESTED WITH RESULT]
    FROM
       VWSINTER.GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE)
END;