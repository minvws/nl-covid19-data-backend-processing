﻿CREATE   PROCEDURE DBO.SP_RIVM_INTAKE_NURSING_HOMES_HANDICAPPED_INFECTED_LOCATIONS_PER_REGION_INTER
AS
BEGIN
-- Main select and insert into statement. Filtered values on max datelastinserted.
-- Move nursery intake data from staging to intermediate table. 
    INSERT INTO VWSINTER.RIVM_NURSING_HOMES_HANDICAPPED_INFECTED_LOCATIONS_PER_REGION
        (
        VEILIGHEIDSREGIOCODE
    ,   VEILIGHEIDSREGIONAAM
    ,   [PUBLICATIEDATUMRIVM]
    ,   [AANTAL_NIEUW_BESMETTE_GEHANDICAPTENZORGINSTELLING_LOCATIES]
    ,   [AANTAL_NIEUW_BESMETTINGSVRIJE_GEHANDICAPTENZORGINSTELLING_LOCATIES]
    ,   [AANTAL_BESMETTE_GEHANDICAPTENZORGINSTELLING_LOCATIES] )
    SELECT
        VEILIGHEIDSREGIOCODE
    ,   VEILIGHEIDSREGIONAAM
    ,	[PUBLICATIEDATUMRIVM]
    ,   [AANTAL_NIEUW_BESMETTE_GEHANDICAPTENZORGINSTELLING_LOCATIES]
    ,   [AANTAL_NIEUW_BESMETTINGSVRIJE_GEHANDICAPTENZORGINSTELLING_LOCATIES]
    ,   [AANTAL_BESMETTE_GEHANDICAPTENZORGINSTELLING_LOCATIES]
    FROM VWSSTAGE.RIVM_NURSING_HOMES_HANDICAPPED_INFECTED_LOCATIONS_PER_REGION
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.RIVM_NURSING_HOMES_HANDICAPPED_INFECTED_LOCATIONS_PER_REGION)
END;