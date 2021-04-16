-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move positive reports data from staging to intermediate table.
CREATE OR ALTER PROCEDURE DBO.SP_CORONAMELDER_POSITIVES_INTER
AS
BEGIN
    INSERT INTO VWSINTER.CORONAMELDER_POSITIVES
        ([Date (yyyy-mm-dd)],
        [Reported positive tests through app authorised by GGD (daily)],
        [Reported positive test through app authorised by GGD (cumulative)])
    SELECT 
        [Date (yyyy-mm-dd)],
        [Reported positive tests through app authorised by GGD (daily)],
        [Reported positive test through app authorised by GGD (cumulative)]
    FROM 
       VWSSTAGE.CORONAMELDER_POSITIVES
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.CORONAMELDER_POSITIVES)
END;
GO