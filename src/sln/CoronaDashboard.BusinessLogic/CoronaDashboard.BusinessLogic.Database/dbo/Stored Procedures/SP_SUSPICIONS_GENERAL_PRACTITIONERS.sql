-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move sewer suspicions general practitioners data from intermediate to production table.
CREATE   PROCEDURE [dbo].[SP_SUSPICIONS_GENERAL_PRACTITIONERS]
AS
BEGIN
    INSERT INTO VWSDEST.SUSPICIONS_GENERAL_PRACTITIONERS
    (
        DIAGNOSE,
        JAAR,
        WEEK,
        WEEK_UNIX,
        [INCIDENTIE],
        [BOVENGRENS],
	    [GESCHAT_AANTAL],
	    [ONDERGRENS])
    SELECT 
        [DIAGNOSE],
        [JAAR],
        [WEEK],
        dbo.CONVERT_ISO_WEEK_TO_UNIX([JAAR], [WEEK]),
        [INCIDENTIE_PER_100000],
        [BOVENGRENS],
        [GESCHAT_AANTAL],
        [ONDERGRENS]
    FROM 
       VWSINTER.NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSINTER.NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS)
END;