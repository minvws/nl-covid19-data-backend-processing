-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move national data from staging to intermediate table.
CREATE OR ALTER PROCEDURE dbo.SP_RIVM_COVID_19_NATIONAL_INTER
AS
BEGIN
    INSERT INTO VWSINTER.RIVM_COVID_19_CASE_NATIONAL
        (DATE_FILE,
        DATE_STATISTICS,
        DATE_STATISTICS_TYPE,
        AGEGROUP,
        SEX,
        PROVINCE,
        HOSPITAL_ADMISSION,
        DECEASED,
        WEEK_OF_DEATH,
        MUNICIPAL_HEALTH_SERVICE)
    SELECT
        DATE_FILE,
        DATE_STATISTICS,
        TRIM(DATE_STATISTICS_TYPE),
        TRIM(AGEGROUP),
        TRIM(SEX),
        TRIM(PROVINCE),
        TRIM(HOSPITAL_ADMISSION),
        TRIM(DECEASED),
        TRIM(WEEK_OF_DEATH),
        TRIM(MUNICIPAL_HEALTH_SERVICE)
    FROM
       VWSSTAGE.RIVM_COVID_19_CASE_NATIONAL
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.RIVM_COVID_19_CASE_NATIONAL)
END;