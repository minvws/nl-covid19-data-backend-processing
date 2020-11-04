-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Disable old proto configuration for hospital admissions
UPDATE [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
SET active = 'false'
WHERE ITEM_NAME = 'intake_hospital_ma'
AND PROTO_ID = (SELECT ID FROM [DATATINO_PROTO].[PROTOS] WHERE PROTO_NAME = 'NL')
AND VIEW_ID = (SELECT ID FROM [DATATINO_PROTO].[VIEWS] WHERE VIEW_NAME = 'VWSDEST.V_HOSPITAL_ADMISSIONS'  )

-- add now proto configuration for hospital admissions
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'intake_hospital_ma', 'VWSDEST.V_HOSPITAL_ADMISSIONS_NICE', 'false', NULL, NULL, 'false', NULL, NULL, 'true'

-- add proto for bed occupancy
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'intensive_care_beds_occupied','VWSDEST.V_IC_BED_OCCUPANCY','false', NULL, NULL, 'false', NULL, NULL, 'true'
exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'hospital_beds_occupied','VWSDEST.V_NON_IC_BED_OCCUPANCY','false', NULL, NULL, 'false', NULL, NULL, 'true'

GO
