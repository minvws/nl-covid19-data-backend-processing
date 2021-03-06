-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER VIEW VWSDEST.V_SEWER_MEASUREMENTS_PER_RWZI_BACK_UP AS
SELECT
    ROW_NUMBER() OVER (ORDER BY DATE_MEASUREMENT_UNIX ASC) AS ID,
    [DATE_MEASUREMENT],
	[DATE_MEASUREMENT_UNIX],
	[WEEK],
	[RWZI_AWZI_CODE],
	[RWZI_AWZI_NAME],
	[VRCODE],
	[VRNAAM],
	[RNA_PER_ML],
	DATE_LAST_INSERTED
FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI);