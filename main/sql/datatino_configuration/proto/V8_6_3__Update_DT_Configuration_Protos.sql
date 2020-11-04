-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Update view to make use of smaller age groups
UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET VIEW_ID = (SELECT ID FROM [DATATINO_PROTO].[VIEWS] WHERE VIEW_NAME = 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_SMALL_AGE_GROUP'  )
WHERE ITEM_NAME = 'intake_share_age_groups'
    AND PROTO_ID = (SELECT ID FROM [DATATINO_PROTO].[PROTOS] WHERE PROTO_NAME = 'NL')
    AND VIEW_ID = (SELECT ID FROM [DATATINO_PROTO].[VIEWS] WHERE VIEW_NAME = 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP'  )

-- Update proto name of infected people
UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET ITEM_NAME = 'ggd'
WHERE ITEM_NAME = 'infected_people_percentage'
    AND PROTO_ID = (SELECT ID FROM [DATATINO_PROTO].[PROTOS] WHERE PROTO_NAME = 'NL')
    AND VIEW_ID = (SELECT ID FROM [DATATINO_PROTO].[VIEWS] WHERE VIEW_NAME = 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PERCENTAGE'  )


-- Turn off old nursing home lines
UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET ACTIVE='false'
WHERE ITEM_NAME = 'infected_people_nursery_count_daily'
    AND PROTO_ID = (SELECT ID FROM [DATATINO_PROTO].[PROTOS] WHERE PROTO_NAME='NL')
    
UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET ACTIVE='false'
WHERE ITEM_NAME = 'deceased_people_nursery_count_daily'
    AND PROTO_ID = (SELECT ID FROM [DATATINO_PROTO].[PROTOS] WHERE PROTO_NAME='NL')

UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET ACTIVE='false'
WHERE ITEM_NAME = 'total_reported_locations'
    AND PROTO_ID = (SELECT ID FROM [DATATINO_PROTO].[PROTOS] WHERE PROTO_NAME='NL')

UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
    SET ACTIVE='false'
WHERE ITEM_NAME = 'total_newly_reported_locations'
    AND PROTO_ID = (SELECT ID FROM [DATATINO_PROTO].[PROTOS] WHERE PROTO_NAME='NL')


-- Fix faulty regional sewer proto configurations
DECLARE @counter_2 INT = 1;
WHILE @counter_2 <= 25
BEGIN
    DECLARE @VRCODE_2 VARCHAR(50) = 'VR' + (SELECT right ('00'+ltrim(str(@counter_2)),2 ))
    DECLARE @GROUPED_KEY_NAME VARCHAR(50) = 'RWZI_AWZI_CODE'
    DECLARE @GROUPED_LAST_UPDATE_NAME VARCHAR(50) = 'DATE_MEASUREMENT_UNIX'

    exec [dbo].[SafeInsertProtoConfiguration] @VRCODE_2, 'average_sewer_installation_per_region', 'VWSDEST.V_SEWER_MEASUREMENTS_PER_REGION', 'true', 'VRCODE', @VRCODE_2, 'false', NULL, NULL, 'true', 'LASTVALUE'

    exec [dbo].[SafeInsertProtoConfiguration] @VRCODE_2, 'results_per_sewer_installation_per_region', 'VWSDEST.V_SEWER_MEASUREMENTS_PER_RWZI', 'true', 'VRCODE', @VRCODE_2, 'true', @GROUPED_KEY_NAME, @GROUPED_LAST_UPDATE_NAME, 'true', 'VALUES'

    SET @counter_2 = @counter_2 + 1;
END;