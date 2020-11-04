-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move percentage positive tested people data from staging to intermediate table.
CREATE OR ALTER PROCEDURE DBO.SP_GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE_INTER
AS
BEGIN
    INSERT INTO VWSINTER.GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE
    (
        [WEEK OF APPOINTMENT],
        [POPULATION],
        [TOTAL TESTED WITH RESULT],
        [TOTAL TESTED WITH RESULT/100.000],
        [TOTAL POSITIVE],
        [% POSITIVE],
        [POSITIVE/100.000]
    )
    SELECT
        [WEEK OF APPOINTMENT],
        [POPULATION],
        [TOTAL TESTED WITH RESULT],
        [TOTAL TESTED WITH RESULT/100.000],
        [TOTAL POSITIVE],
        [% POSITIVE],
        [POSITIVE/100.000]
    FROM
       VWSSTAGE.GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.GGD_PERCENTAGE_POSITIVE_TESTED_PEOPLE)
END;