-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move data Suspicions General Practitioners data from staging to intermediate table.
-- The commas are replaced by full stops to ensure data will be processed as decimals.
CREATE OR ALTER PROCEDURE [dbo].[SP_NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS_INTER]
AS
BEGIN
    INSERT INTO VWSINTER.NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS
    ([DIAGNOSE],
        [JAAR],
        [WEEK],
        [INCIDENTIE_PER_100000],
        [BOVENGRENS],
        [GESCHAT_AANTAL],
        [ONDERGRENS] )
    SELECT 
        [DIAGNOSE],
        [JAAR],
        [WEEK],
        REPLACE([INCIDENTIE_PER_100000], ',', '.'),
        [BOVENGRENS],
        [GESCHAT_AANTAL],
        [ONDERGRENS]
    FROM 
       VWSSTAGE.NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS)
END;


