-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_RIVM_INTAKE_NURSING_HOMES_DECEASED_INTER
AS
BEGIN
-- Main select and insert into statement. Filtered values on max datelastinserted.
-- Move nursery intake data from staging to intermediate table. 
    INSERT INTO VWSINTER.RIVM_NURSING_HOMES_DECEASED
        (DATUM_VAN_OVERLIJDEN
    ,	AANTAL)
    SELECT
		 DATUM_VAN_OVERLIJDEN
    ,    AANTAL
    FROM VWSSTAGE.RIVM_NURSING_HOMES_DECEASED
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.RIVM_NURSING_HOMES_DECEASED)
END;