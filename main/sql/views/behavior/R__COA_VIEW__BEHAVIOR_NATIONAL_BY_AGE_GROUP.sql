-- Copyright (c) 2021 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER VIEW [VWSDEST].[V_BEHAVIOR_NATIONAL_BY_AGE_GROUP]
AS   
    SELECT	  
        CASE
            WHEN INDICATOR = 'Avondklok' THEN 'curfew'
            WHEN INDICATOR = 'Draag_mondkapje_in_publieke_binnenruimtes' THEN 'wear_mask_public_indoors'
            WHEN INDICATOR = 'Hoest_niest_in_elleboog' THEN 'sneeze_cough_elbow'
            WHEN INDICATOR = 'Houd_1_5m_afstand' THEN 'keep_distance'
            WHEN INDICATOR = 'Ontvang_max_bezoekers_thuis' THEN 'max_visitors'
            WHEN INDICATOR = 'Vermijd_drukke_plekken' THEN 'avoid_crowds'
            WHEN INDICATOR = 'Was_vaak_je_handen' THEN 'wash_hands'
            WHEN INDICATOR = 'Werkt_thuis' THEN 'work_from_home'
        END
        + '_' +
        CASE
            WHEN INDICATOR_CATEGORY = 'Draagvlak' THEN 'support'
            WHEN INDICATOR_CATEGORY = 'Naleving' THEN 'compliance'
        END                                                                         AS [CONSTRAINT_KEY]
        ,[16-24]                                                                    AS [16_24] 
        ,[25-39]                                                                    AS [25_39]
        ,[40-54]                                                                    AS [40_54] 
        ,[55-69]                                                                    AS [55_69]
        ,[70+]                                                                      AS [70_plus]
        ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_MEASUREMENT])                        AS [date_start_unix]
        ,dbo.CONVERT_DATETIME_TO_UNIX(DATEADD(day, 6, [DATE_OF_MEASUREMENT]))       AS [date_end_unix]
        ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)                           AS [date_of_insertion_unix]
    FROM (
        SELECT 
            DATE_LAST_INSERTED, DATE_OF_MEASUREMENT, SUBGROUP, INDICATOR_CATEGORY, INDICATOR, [VALUE]
        FROM
            [VWSDEST].[BEHAVIOR_NATIONAL_BY_AGE_GROUP]
        WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[BEHAVIOR_NATIONAL_BY_AGE_GROUP])
        ) SELECT_SOURCE
    PIVOT  
        (MAX([VALUE]) -- Only one value available
        FOR [SUBGROUP] IN ([16-24], [25-39], [40-54], [55-69], [70+])  
    ) AS PivotTable; 
