-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_GGD_TESTED_PEOPLE_INTER
AS
BEGIN
    INSERT INTO VWSINTER.GGD_TESTED_PEOPLE
    (
       [VERSION],
       DATE_OF_REPORT,
       DATE_OF_STATISTICS,
       SECURITY_REGION_CODE,
       SECURITY_REGION_NAME,
       TESTED_WITH_RESULT,
       TESTED_POSITIVE
    )
    SELECT
        [VERSION],
        DATE_OF_REPORT,
        DATE_OF_STATISTICS,
        SECURITY_REGION_CODE,
        SECURITY_REGION_NAME,
        TESTED_WITH_RESULT,
        TESTED_POSITIVE
    FROM
       VWSSTAGE.GGD_TESTED_PEOPLE
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.GGD_TESTED_PEOPLE)
END;