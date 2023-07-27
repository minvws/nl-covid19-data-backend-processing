-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE [dbo].[SP_AGEGROUP_MAPPING]
AS
BEGIN
    INSERT INTO VWSSTATIC.CBS_AGEGROUP_MAPPING
    ([KEY], [TITLE], [DESCRIPTION], [CATEGORYGROUPID])
    SELECT
        [KEY],
        [TITLE],
-- translating the different category IDs to the agegroup description that we are using        
        CASE
            WHEN [CATEGORYGROUPID] = 2 THEN '0-9'
            WHEN [CATEGORYGROUPID] = 3 THEN '10-19'
            WHEN [CATEGORYGROUPID] = 4 THEN '20-29'
            WHEN [CATEGORYGROUPID] = 5 THEN '30-39'
            WHEN [CATEGORYGROUPID] = 6 THEN '40-49'
            WHEN [CATEGORYGROUPID] = 7 THEN '50-59'
            WHEN [CATEGORYGROUPID] = 8 THEN '60-69'
            WHEN [CATEGORYGROUPID] = 9 THEN '70-79'
            WHEN [CATEGORYGROUPID] = 10 THEN '80-89'
            WHEN [CATEGORYGROUPID] > 10 AND TITLE <> '95 jaar of ouder' THEN '90+'
        END AS [DESCRIPTION],
        [CATEGORYGROUPID]
    FROM VWSSTAGE.CBS_AGEGROUP_MAPPING
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.CBS_AGEGROUP_MAPPING)
END;