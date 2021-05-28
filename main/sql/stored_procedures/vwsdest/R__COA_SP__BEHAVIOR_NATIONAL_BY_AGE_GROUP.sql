-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE  OR ALTER  PROCEDURE [dbo].[SP_BEHAVIOR_NATIONAL_BY_AGE_GROUP]
AS
BEGIN
    INSERT INTO
        VWSDEST.BEHAVIOR_NATIONAL_BY_AGE_GROUP (
            DATE_OF_REPORT,
            DATE_OF_MEASUREMENT,
            WAVE,
            REGION_CODE,
            SUBGROUP_CATEGORY,
            SUBGROUP,
            INDICATOR_CATEGORY,
            INDICATOR,
            FIGURE_TYPE,
            [VALUE]
        )

    SELECT 
        DATE_OF_REPORT,
        DATE_OF_MEASUREMENT,
        WAVE,
        REGION_CODE,
        SUBGROUP_CATEGORY,
        SUBGROUP,
        INDICATOR_CATEGORY,
        INDICATOR,
        FIGURE_TYPE,
        CONVERT(INT, ROUND([VALUE], 0)) AS [VALUE]   
    FROM 
        VWSINTER.VWS_BEHAVIOR
    WHERE
        -- Last File
        DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.VWS_BEHAVIOR) AND
        -- Last Wave
        WAVE = (SELECT MAX(WAVE) FROM VWSINTER.VWS_BEHAVIOR ) AND
        -- Region NL
        REGION_CODE = 'NL00' AND
        -- Age Groups
        SUBGROUP_CATEGORY = 'Leeftijd' AND
        -- Age Group Selection
        SUBGROUP IN ('16-24', '25-39', '40-54' , '55-69', '70+') AND
        -- Indicator category Selection
        INDICATOR_CATEGORY IN ('Draagvlak', 'Naleving') AND
        -- Indicator Selection
        INDICATOR IN (
                 'Avondklok'
                ,'Draag_mondkapje_in_publieke_binnenruimtes'
                ,'Vermijd_drukke_plekken'
                ,'Ontvang_max_bezoekers_thuis'
                ,'Werkt_thuis'
                ,'Hoest_niest_in_elleboog'
                ,'Houd_1_5m_afstand'
                ,'Was_vaak_je_handen'
        )

END;
GO