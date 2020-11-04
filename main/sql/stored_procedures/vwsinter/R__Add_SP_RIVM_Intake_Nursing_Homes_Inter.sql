-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_RIVM_INTAKE_NURSING_HOMES_INTER
AS
BEGIN
-- Main select and insert into statement. Filtered values on max datelastinserted.
-- Move nursery intake data from staging to intermediate table. 
    INSERT INTO VWSINTER.RIVM_NURSING_HOMES_INTAKE
        (DATE_OF_REPORT
    ,	TOTAL_REPORTED_NURSING_HOMES
    ,   DECEASED_NURSING_HOMES
    ,   TOTAL_NEW_REPORTED_LOCATIONS
    ,   TOTAL_REPORTED_LOCATIONS)
    SELECT
		 DATE_OF_REPORT
    ,    TOTAL_REPORTED_NURSING_HOMES
    ,    DECEASED_NURSING_HOMES
    ,    TOTAL_NEW_REPORTED_LOCATIONS
    ,    TOTAL_REPORTED_LOCATIONS
    FROM VWSSTAGE.RIVM_NURSING_HOMES_INTAKE
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.RIVM_NURSING_HOMES_INTAKE)
END;