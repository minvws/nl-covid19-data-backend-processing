-- Dit was de fix van vandaag mbt nieuwe rioolwater data. We kunnen dit niet zo opnemen in Flyway. Tabel is immers leeg met het laden. We moeten hiervoor de verwijzing naar static hanteren.
-- Hiervoor dient een stored procedure gemaakt te worden die static table van sewer periodiek update, zodat dit in het migratie script meegenomen kan worden.
DECLARE @gmcode NVARCHAR(100)
DECLARE @getgmcode CURSOR

SET @getgmcode = CURSOR FOR
SELECT distinct [GMCODE]
  FROM [VWSSTATIC].[SAFETY_REGIONS_PER_MUNICIPAL]
    WHERE GMCODE in (select distinct gmcode from VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY) 

OPEN @getgmcode
FETCH NEXT
FROM @getgmcode INTO @gmcode
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC [dbo].[SafeInsertProtoConfiguration] @gmcode, 'results_per_sewer_installation_per_municipality', 'VWSDEST.V_SEWER_MEASUREMENTS_PER_RWZI_MINIMAL', 'true', 'GMCODE', @gmcode, 'true', RWZI_AWZI_CODE, DATE_MEASUREMENT_UNIX, 'true', 'VALUES'
    EXEC [dbo].[SafeInsertProtoConfiguration] @gmcode,  'sewer_measurements', 'VWSDEST.V_SEWER_MEASUREMENTS_PER_MUNICIPALITY', 'true', 'GMCODE', @gmcode, 'false', NULL, NULL, 'true', 'LASTVALUE'
    FETCH NEXT
    FROM @getgmcode INTO @gmcode
END

CLOSE @getgmcode
DEALLOCATE @getgmcode

-- Regional proto configurations
DECLARE @counter INT = 1;
WHILE @counter <= 25
BEGIN
    DECLARE @VRCODE VARCHAR(50) = 'VR' + (SELECT right ('00'+ltrim(str(@counter)),2 ))

    exec [dbo].[SafeInsertProtoConfiguration] @VRCODE, 'ggd', 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PERCENTAGE_PER_REGION', 'true', 'VRCODE', @VRCODE, 'false', NULL, NULL, 'true', 'LASTVALUE'
    SET @counter = @counter + 1;
END;
