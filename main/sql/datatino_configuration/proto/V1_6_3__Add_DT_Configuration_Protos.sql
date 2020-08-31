-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Proto configurations for national data
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'verdenkingen_huisartsen', 'VWSDEST.V_GENERAL_PRACTITIONERS', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'intake_hospital_ma', 'VWSDEST.V_HOSPITAL_ADMISSIONS', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'infectious_people_count', 'VWSDEST.V_INFECTIOUS_PEOPLE', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'infectious_people_count_normalized', 'VWSDEST.V_INFECTIOUS_PEOPLE_NORMALIZED', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'intake_intensivecare_ma', 'VWSDEST.V_INTENSIVE_CARE_ADMISSIONS', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'infected_people_nursery_count_daily', 'VWSDEST.V_NURSING_HOMES_TOTALS_INFECTED', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'deceased_people_nursery_count_daily', 'VWSDEST.V_NURSING_HOMES_TOTALS_DECEASED', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'total_reported_locations', 'VWSDEST.V_NURSING_HOMES_TOTALS_LOCATIONS', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'total_newly_reported_locations', 'VWSDEST.V_NURSING_HOMES_TOTALS_NEW_LOCATIONS', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'infected_people_total', 'VWSDEST.V_POSITIVE_TESTED_PEOPLE', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'infected_people_delta_normalized', 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_DELTA', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'intake_share_age_groups', 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'reproduction_index', 'VWSDEST.V_REPRODUCTION_NUMBER', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'reproduction_index_last_known_average', 'VWSDEST.V_REPRODUCTION_NUMBER_LAST_KNOWN', 'false', NULL, NULL, 'false', NULL, NULL, 'true';
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'rioolwater_metingen','VWSDEST.V_SEWER_MEASUREMENTS','false', NULL, NULL, 'false', NULL, NULL, 'true';

-- Regional proto configurations
DECLARE @counter_1 INT = 1;
WHILE @counter_1 <= 25
BEGIN
    DECLARE @VRCODE NVARCHAR(50) = 'VR' + (SELECT right ('00'+ltrim(str(@counter_1)),2 ))

    exec [dbo].[SafeInsertProtoConfiguration] @VRCODE, 'results_per_region', 'VWSDEST.V_RESULTS_PER_REGION', 'true', 'VRCODE', @VRCODE, 'false', NULL, NULL, 'true';

    SET @counter_1 = @counter_1 + 1;
END;

-- Configuration for minimum and maximum values
exec [dbo].[SafeInsertProtoConfiguration] 'RANGES', 'min_max_values', 'VWSDEST.V_VWS_MAX_AND_MIN', 'false', NULL, NULL, 'false', NULL, NULL, 'true';

-- Proto configurations for national data

exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'rioolwater_metingen_per_rwzi','VWSDEST.V_LATEST_SEWER_MEASUREMENTS_PER_RWZI','false', NULL, NULL, 'false', NULL, NULL, 'true';

-- Regional proto configurations
DECLARE @counter_2 INT = 1;
WHILE @counter_2 <= 25
BEGIN
    DECLARE @VRCODE_2 VARCHAR(50) = 'VR' + (SELECT right ('00'+ltrim(str(@counter_2)),2 ))
    DECLARE @GROUPED_KEY_NAME VARCHAR(50) = 'RWZI_AWZI_CODE'
    DECLARE @GROUPED_LAST_UPDATE_NAME VARCHAR(50) = 'DATE_MEASUREMENT_UNIX'

    exec [dbo].[SafeInsertProtoConfiguration] @VRCODE_2, 'average_sewer_installation_per_region ', 'VWSDEST.V_SEWER_MEASUREMENTS_PER_REGION', 'true', 'VRCODE', @VRCODE, 'false', NULL, NULL, 'true'

    exec [dbo].[SafeInsertProtoConfiguration] @VRCODE, 'results_per_sewer_installation_per_region', 'VWSDEST.V_SEWER_MEASUREMENTS_PER_RWZI', 'true', 'VRCODE', @VRCODE, 'true', @GROUPED_KEY_NAME, @GROUPED_LAST_UPDATE_NAME, 'true'

    SET @counter_2 = @counter_2 + 1;
END;

-- Municipality configuration
DECLARE @gmcode NVARCHAR(100)
DECLARE @getgmcode CURSOR

SET @getgmcode = CURSOR FOR
SELECT distinct [GMCODE]
  FROM [VWSSTATIC].[SAFETY_REGIONS_PER_MUNICIPAL]

OPEN @getgmcode
FETCH NEXT
FROM @getgmcode INTO @gmcode
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC [dbo].[SafeInsertProtoConfiguration] @gmcode, 'hospital_admissions', 'VWSDEST.V_HOSPITAL_ADMISSIONS_PER_MUNICIPALITY', 'true', 'GMCODE', @gmcode, 'false', NULL, NULL, 'true';
    EXEC [dbo].[SafeInsertProtoConfiguration] @gmcode, 'positive_tested_people', 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY', 'true', 'GMCODE', @gmcode, 'false', NULL, NULL, 'true';
    EXEC [dbo].[SafeInsertProtoConfiguration] @gmcode, 'results_per_sewer_installation_per_municipality', 'VWSDEST.V_SEWER_MEASUREMENTS_PER_RWZI_MINIMAL', 'true', 'GMCODE', @gmcode, 'true', RWZI_AWZI_CODE, DATE_MEASUREMENT_UNIX, 'true';
    FETCH NEXT
    FROM @getgmcode INTO @gmcode
END

CLOSE @getgmcode
DEALLOCATE @getgmcode

GO
