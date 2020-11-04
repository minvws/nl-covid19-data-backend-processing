-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.


-- Update national sewer proto names
    -- NL rioolwater_metingen => sewer
UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET ITEM_NAME = 'sewer'
WHERE ITEM_NAME = 'rioolwater_metingen'
    AND PROTO_ID = (SELECT ID FROM [DATATINO_PROTO].[PROTOS] WHERE PROTO_NAME = 'NL')

    -- NL rioolwater_metingen_per_rwzi => sewer_per_installation
UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET ITEM_NAME = 'sewer_per_installation'
WHERE ITEM_NAME = 'rioolwater_metingen_per_rwzi'
    AND PROTO_ID = (SELECT ID FROM [DATATINO_PROTO].[PROTOS] WHERE PROTO_NAME = 'NL')


-- Update Regional sewer proto names
    -- VR average_sewer_installation_per_region => sewer
UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET ITEM_NAME = 'sewer'
WHERE ITEM_NAME = 'average_sewer_installation_per_region'
    AND CONSTRAINT_KEY_NAME='VRCODE'

    -- VR results_per_sewer_installation_per_region => sewer_per_installation
UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET ITEM_NAME = 'sewer_per_installation'
WHERE ITEM_NAME = 'results_per_sewer_installation_per_region'
    AND CONSTRAINT_KEY_NAME='VRCODE'

-- Municipality configuration
DECLARE @gmcode NVARCHAR(100)
DECLARE @getgmcode CURSOR

SET @getgmcode = CURSOR FOR
  SELECT distinct [GMCODE]
  FROM [VWSSTATIC].[SAFETY_REGIONS_PER_MUNICIPAL]
  WHERE GMCODE in (select GMCODE 
                    FROM  [VWSSTATIC].[GMCODES_WITH_SEWER_MEASUREMENTS]) 
OPEN @getgmcode
FETCH NEXT
FROM @getgmcode INTO @gmcode
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC [dbo].[SafeInsertProtoConfiguration] @gmcode, 'sewer_per_installation', 'VWSDEST.V_SEWER_MEASUREMENTS_PER_RWZI_MINIMAL', 'true', 'GMCODE', @gmcode, 'true', RWZI_AWZI_CODE, DATE_MEASUREMENT_UNIX, 'true', 'VALUES'
    EXEC [dbo].[SafeInsertProtoConfiguration] @gmcode,  'sewer', 'VWSDEST.V_SEWER_MEASUREMENTS_PER_MUNICIPALITY', 'true', 'GMCODE', @gmcode, 'false', NULL, NULL, 'true', 'LASTVALUE'
    FETCH NEXT
    FROM @getgmcode INTO @gmcode
END

CLOSE @getgmcode
DEALLOCATE @getgmcode


-- Add chloropleth for sewer to REGIONS
exec [dbo].[SafeInsertProtoConfiguration] 'regions', 'sewer', 'VWSDEST.V_SEWER_MEASUREMENTS_REGIONS', 'false', NULL, NULL, 'false', NULL, NULL, 'true', 'VALUESDIRECT'