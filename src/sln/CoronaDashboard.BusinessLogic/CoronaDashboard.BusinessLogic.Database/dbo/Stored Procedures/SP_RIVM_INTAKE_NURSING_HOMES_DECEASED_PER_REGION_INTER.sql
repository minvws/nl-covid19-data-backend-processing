﻿CREATE   PROCEDURE DBO.SP_RIVM_INTAKE_NURSING_HOMES_DECEASED_PER_REGION_INTER
AS
BEGIN
-- Main select and insert into statement. Filtered values on max datelastinserted.
-- Move nursery intake data from staging to intermediate table. 
    INSERT INTO VWSINTER.RIVM_NURSING_HOMES_DECEASED_PER_REGION
        (
        VEILIGHEIDSREGIOCODE
    ,   VEILIGHEIDSREGIONAAM
    ,   DATUM_VAN_OVERLIJDEN
    ,	AANTAL)
    SELECT
         VEILIGHEIDSREGIOCODE
    ,    VEILIGHEIDSREGIONAAM
    ,	 DATUM_VAN_OVERLIJDEN
    ,    AANTAL
    FROM VWSSTAGE.RIVM_NURSING_HOMES_DECEASED_PER_REGION
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.RIVM_NURSING_HOMES_DECEASED_PER_REGION)
END;