-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER PROCEDURE [dbo].[SP_CBS_DECEASED_PER_WEEK_INTER]
AS
BEGIN
INSERT INTO VWSINTER.CBS_DECEASED_PER_WEEK(
    [YEAR]
,   [WEEK]
,   [DECEASED_ACTUAL]
    )
SELECT
-- So we make substrings of the given perioden column. This will work until the year
-- 9999 which seems adequate for now
    CAST(SUBSTRING([PERIODEN], 1, 4) AS INT)
,   CAST(SUBSTRING([PERIODEN], 7, 2) AS INT)
,   [OVERLEDENEN_1]
FROM [VWSSTAGE].[CBS_DECEASED_PER_WEEK]
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.CBS_DECEASED_PER_WEEK)
END;
