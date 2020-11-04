-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move municipality cumulative data from staging to intermediate table.
CREATE OR ALTER PROCEDURE DBO.SP_RIVM_COVID_19_MUNICIPALITY_CUMULATIVE_INTER
AS
BEGIN
    INSERT INTO VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE
    (DATE_OF_REPORT,
        MUNICIPALITY_CODE,
        MUNICIPALITY_NAME,
        PROVINCE,
        TOTAL_REPORTED,
        HOSPITAL_ADMISSION,
        DECEASED)
    SELECT 
        DATE_OF_REPORT,
        TRIM(MUNICIPALITY_CODE),
        TRIM(MUNICIPALITY_NAME),
        TRIM(PROVINCE),
        TOTAL_REPORTED,
        HOSPITAL_ADMISSION,
        DECEASED
    FROM 
       VWSSTAGE.RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE)
END;