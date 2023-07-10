﻿CREATE   PROCEDURE DBO.SP_RIVM_INTAKE_NURSING_HOMES_INFECTED_LOCATIONS_INTER
AS
BEGIN
-- Main select and insert into statement. Filtered values on max datelastinserted.
-- Move nursery intake data from staging to intermediate table. 
    INSERT INTO VWSINTER.RIVM_NURSING_HOMES_INFECTED_LOCATIONS
        ([PUBLICATIEDATUMRIVM]
    ,   [AANTAL_NIEUW_BESMETTE_VERPLEEGHUIS_LOCATIES]
    ,   [AANTAL_NIEUW_BESMETTINGSVRIJE_VERPLEEGHUIS_LOCATIES]
    ,   [AANTAL_BESMETTE_VERPLEEGHUIS_LOCATIES] )
    SELECT
		[PUBLICATIEDATUMRIVM]
    ,   [AANTAL_NIEUW_BESMETTE_VERPLEEGHUIS_LOCATIES]
    ,   [AANTAL_NIEUW_BESMETTINGSVRIJE_VERPLEEGHUIS_LOCATIES]
    ,   [AANTAL_BESMETTE_VERPLEEGHUIS_LOCATIES]
    FROM VWSSTAGE.RIVM_NURSING_HOMES_INFECTED_LOCATIONS
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.RIVM_NURSING_HOMES_INFECTED_LOCATIONS)
END;