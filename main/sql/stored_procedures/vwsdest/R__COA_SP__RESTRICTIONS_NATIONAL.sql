-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move national restriction data from intermediate to production table.
CREATE OR ALTER PROCEDURE [dbo].[SP_RESTRICTIONS_NATIONAL]
AS
BEGIN

    INSERT INTO VWSDEST.RESTRICTIONS_NATIONAL
    (
            RESTRICTION_ID
        ,   TARGET_REGION
        ,   ESCALATION_LEVEL
        ,   CATEGORY_ID
        ,   RESTRICTION_ORDER
        ,   VALID_FROM
    )
    SELECT
            -- <escalation-level>_<category_id>_<unique-number>
            CONCAT(
                CAST([ESCALATION_LEVEL] AS VARCHAR),
                '_',
                LOWER([CATEGORY_ID]),
                '_',
                CAST([IDENTIFIER] AS VARCHAR)
            ) AS RESTRICTION_ID
        ,   LOWER([TARGET_REGION])
        ,   [ESCALATION_LEVEL]
        ,   LOWER([CATEGORY_ID])
        ,   [RESTRICTION_ORDER]
        ,   VALID_FROM
    FROM VWSINTER.VWS_RESTRICTIONS_MAPPING
        WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.VWS_RESTRICTIONS_MAPPING)
        AND LOWER([TARGET_REGION]) = 'nl'
END;