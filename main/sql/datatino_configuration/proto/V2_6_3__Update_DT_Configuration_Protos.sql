-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'infected_people_percentage','VWSDEST.V_POSITIVE_TESTED_PEOPLE_PERCENTAGE','false', NULL, NULL, 'false', NULL, NULL, 'true', 'LASTVALUE'

exec [dbo].[SafeInsertProtoConfiguration] 'regions', 'escalation_levels', 'VWSDEST.V_ESCALATIONLEVELS_PER_REGION', 'false', Null, Null , 'false', NULL, NULL, 'true', 'VALUESDIRECT'

exec [dbo].[SafeInsertProtoConfiguration] 'regions', 'positive_tested_people', 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_REGION', 'false', NULL, NULL, 'false', NULL, NULL, 'true', 'VALUESDIRECT'
exec [dbo].[SafeInsertProtoConfiguration] 'regions', 'hospital_admissions','VWSDEST.V_HOSPITAL_ADMISSIONS_PER_REGION','false', NULL, NULL, 'false', NULL, NULL, 'true', 'VALUESDIRECT'
exec [dbo].[SafeInsertProtoConfiguration] 'regions', 'deceased', 'VWSDEST.V_DECEASED_PER_REGION ', 'false', NULL, NULL, 'false', NULL, NULL, 'true', 'VALUESDIRECT'

exec [dbo].[SafeInsertProtoConfiguration] 'municipalities', 'positive_tested_people','VWSDEST.V_POS_TESTED_PEOPLE_PER_MUNICIPALITY_LAST ','false', NULL, NULL, 'false', NULL, NULL, 'true', 'VALUESDIRECT'
exec [dbo].[SafeInsertProtoConfiguration] 'municipalities', 'hospital_admissions', 'VWSDEST.V_HOSP_ADMISSIONS_PER_MUNICIPALITY_LAST', 'false', NULL, NULL, 'false', NULL, NULL, 'true', 'VALUESDIRECT'
exec [dbo].[SafeInsertProtoConfiguration] 'municipalities', 'deceased','VWSDEST.V_DECEASED_PER_MUNICIPALITY_LAST','false', NULL, NULL, 'false', NULL, NULL, 'true', 'VALUESDIRECT'

UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
SET ITEM_NAME = 'average_sewer_installation_per_region'
WHERE ITEM_NAME = 'average_sewer_installation_per_region '

UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
SET layout_id = 4
WHERE item_name = 'results_per_sewer_installation_per_municipality'

DECLARE @counter_2 INT = 1;
WHILE @counter_2 <= 25
BEGIN
    DECLARE @VRCODE VARCHAR(50) = 'VR' + (SELECT right ('00'+ltrim(str(@counter_2)),2 ))
    DECLARE @GROUPED_KEY_NAME VARCHAR(50) = 'RWZI_AWZI_CODE'
    DECLARE @GROUPED_LAST_UPDATE_NAME VARCHAR(50) = 'DATE_MEASUREMENT_UNIX'

    exec [dbo].[SafeInsertProtoConfiguration] @VRCODE, 'results_per_sewer_installation_per_region', 'VWSDEST.V_SEWER_MEASUREMENTS_PER_RWZI_REG', 'true', 'VRCODE', @VRCODE, 'true', @GROUPED_KEY_NAME, @GROUPED_LAST_UPDATE_NAME, 'true', 'VALUES'
    SET @counter_2 = @counter_2 + 1;
END;


DECLARE @gmcode NVARCHAR(100)
DECLARE @getgmcode CURSOR

SET @getgmcode = CURSOR FOR
SELECT distinct [GMCODE]
  FROM [VWSSTATIC].[SAFETY_REGIONS_PER_MUNICIPAL]
    WHERE GMCODE in (select GMCODE 
                    FROM  VWSSTATIC.GMCODES_WITH_SEWER_MEASUREMENTS) 

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



GO