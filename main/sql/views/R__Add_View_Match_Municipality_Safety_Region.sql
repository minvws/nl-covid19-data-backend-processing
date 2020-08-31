-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- View to disclose link between municipality and veiligheids regio to front end
CREATE VIEW VWSDEST.V_MATCH_MUNICIPALITY_SAFETY_REGION
AS
SELECT 
    GMNAAM AS [MUNICIPALITY_NAME],
	VRCODE AS [VRCODE]
FROM [VWSSTATIC].[SAFETY_REGIONS_PER_MUNICIPAL]
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM [VWSSTATIC].[SAFETY_REGIONS_PER_MUNICIPAL]);