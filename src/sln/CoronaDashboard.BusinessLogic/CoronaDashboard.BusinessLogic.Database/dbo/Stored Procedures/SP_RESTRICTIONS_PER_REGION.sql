-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move regional restriction data from intermediate to production table.
CREATE   PROCEDURE [dbo].[SP_RESTRICTIONS_PER_REGION]
AS
BEGIN
    WITH BASE_CTE AS (
        SELECT
                [REGION_ID]
            ,   [RESTRICTION_IDENTIFIER]
            ,   VALID_FROM
        FROM VWSINTER.VWS_RESTRICTIONS_MAPPING_PER_REGION
            WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.VWS_RESTRICTIONS_MAPPING_PER_REGION)
    ),
    SECOND_CTE AS (
        SELECT
                [IDENTIFIER]
            ,   [TARGET_REGION]
            ,   [ESCALATION_LEVEL]
            ,   [CATEGORY_ID]
            ,   [RESTRICTION_ORDER]
            ,   VALID_FROM
        FROM VWSINTER.VWS_RESTRICTIONS_MAPPING
            WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.VWS_RESTRICTIONS_MAPPING)
    )

    INSERT INTO VWSDEST.RESTRICTIONS_PER_REGION
    (
            VRCODE
        ,   RESTRICTION_ID
        ,   TARGET_REGION
        ,   ESCALATION_LEVEL
        ,   CATEGORY_ID
        ,   RESTRICTION_ORDER
        ,   VALID_FROM
    )
    SELECT
            BASE.[REGION_ID] AS VRCODE
            -- <escalation-level>_<category_id>_<unique-number>
        ,   CONCAT(
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
        ,   BASE.VALID_FROM
    FROM BASE_CTE BASE
    LEFT JOIN SECOND_CTE SECOND ON SECOND.[IDENTIFIER] = BASE.[RESTRICTION_IDENTIFIER]
END;