-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE [dbo].[SP_VWS_RESTRICTIONS_MAPPING]
AS
BEGIN
    INSERT INTO VWSINTER.VWS_RESTRICTIONS_MAPPING (
            [IDENTIFIER]
        ,   [TARGET_REGION]
        ,   [ESCALATION_LEVEL]
        ,   [CATEGORY_ID]
        ,   [RESTRICTION_ORDER]
        ,   VALID_FROM
    )
    SELECT 
            [IDENTIFIER]
        ,   [TARGET_REGION]
        ,   [ESCALATION_LEVEL]
        ,   [CATEGORY_ID]
        ,   [RESTRICTION_ORDER]
        -- Datetime format in source file is dd-mm-yyyy
        ,   CONVERT(DATETIME, VALID_FROM, 105) AS VALID_FROM
    FROM 
       VWSSTAGE.VWS_RESTRICTIONS_MAPPING
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.VWS_RESTRICTIONS_MAPPING)
END;