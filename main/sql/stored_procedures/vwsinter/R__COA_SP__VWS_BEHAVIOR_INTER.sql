-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_VWS_BEHAVIOR_INTER
AS
BEGIN
    INSERT INTO VWSINTER.VWS_BEHAVIOR
    (
        [DATE_OF_REPORT],
        [DATE_OF_MEASUREMENT],
        [WAVE],
        [REGION_CODE],
        [REGION_NAME],
        [SUBGROUP_CATEGORY],
        [SUBGROUP],
        [INDICATOR_CATEGORY],
        [INDICATOR],
        [SAMPLE_SIZE],
        [FIGURE_TYPE],
        [VALUE],
        [LOWER_LIMIT],
        [UPPER_LIMIT],
        [CHANGE_WRT_PREVIOUS_MEASUREMENT]
    )
    SELECT 
        -- Provided datetime format in source file is yyyy-mm-dd
        CONVERT(DATETIME, [DATE_OF_REPORT], 102),
        CONVERT(DATETIME, [DATE_OF_MEASUREMENT], 102),
        TRIM([WAVE]),
        TRIM([REGION_CODE]),
        [REGION_NAME],
        TRIM([SUBGROUP_CATEGORY]),
        TRIM([SUBGROUP]),
        TRIM([INDICATOR_CATEGORY]),
        TRIM([INDICATOR]),
        CAST(ISNULL(NULLIF([SAMPLE_SIZE], ''), 0) AS INT),
        TRIM([FIGURE_TYPE]),
        CAST(NULLIF([VALUE],'') AS FLOAT),
        CAST(NULLIF([LOWER_LIMIT],'') AS FLOAT),
        CAST(NULLIF([UPPER_LIMIT],'') AS FLOAT),
        CAST(NULLIF([CHANGE_WRT_PREVIOUS_MEASUREMENT], '') AS INT)
    FROM 
       VWSSTAGE.VWS_BEHAVIOR
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.VWS_BEHAVIOR)
END;
GO