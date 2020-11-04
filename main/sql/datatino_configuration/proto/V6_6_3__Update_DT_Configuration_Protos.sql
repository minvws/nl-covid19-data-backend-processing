-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'nursing_home','VWSDEST.V_NURSING_HOMES_NATIONAL','false', NULL, NULL, 'false', NULL, NULL, 'true', 'LASTVALUE'

-- Regional proto configurations
DECLARE @counter INT = 1;
WHILE @counter <= 25
BEGIN
    DECLARE @VRCODE VARCHAR(50) = 'VR' + (SELECT right ('00'+ltrim(str(@counter)),2 ))

    exec [dbo].[SafeInsertProtoConfiguration] @VRCODE, 'nursing_home', 'VWSDEST.V_NURSING_HOMES_PER_REGION', 'true', 'VRCODE', @VRCODE, 'false', NULL, NULL, 'true', 'LASTVALUE'
    SET @counter = @counter + 1;
END;

exec [dbo].[SafeInsertProtoConfiguration] 'regions', 'nursing_home', 'VWSDEST.V_NURSING_HOME_REGIONS', 'false', NULL, NULL, 'false', NULL, NULL, 'true', 'VALUESDIRECT'