-- Copyright (c) 2021 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   VIEW [VWSDEST].[V_BEHAVIOR_NATIONAL_BY_AGE_GROUP]
 AS
     WITH CTE AS (
         SELECT
             CASE
                 WHEN LOWER(INDICATOR) = 'avondklok' THEN 'curfew'
                 WHEN LOWER(INDICATOR) = 'draag_mondkapje_in_publieke_binnenruimtes' THEN 'wear_mask_public_indoors'
                 WHEN LOWER(INDICATOR) = 'hoest_niest_in_elleboog' THEN 'sneeze_cough_elbow'
                 WHEN LOWER(INDICATOR) = 'houd_1_5m_afstand' THEN 'keep_distance'
                 WHEN LOWER(INDICATOR) = 'ontvang_max_bezoekers_thuis' THEN 'max_visitors'
                 WHEN LOWER(INDICATOR) = 'vermijd_drukke_plekken' THEN 'avoid_crowds'
                 WHEN LOWER(INDICATOR) = 'was_vaak_je_handen' THEN 'wash_hands'
                 WHEN LOWER(INDICATOR) = 'werkt_thuis' THEN 'work_from_home'
                 WHEN LOWER(INDICATOR) = 'ventileren_woning' THEN 'ventilate_home'
                 WHEN LOWER(INDICATOR) = 'zelftest_bezoek' THEN 'selftest_visit'
                 WHEN LOWER(INDICATOR) = 'Bij_klachten_postest_isolatie' THEN 'posttest_isolation'
             END
             + '_' +
             CASE
                 WHEN LOWER(INDICATOR_CATEGORY) = 'draagvlak' THEN 'support'
                 WHEN LOWER(INDICATOR_CATEGORY) = 'naleving' THEN 'compliance'
             END AS [constraint_key]
             ,[16-24] AS [16_24]
             ,[25-39] AS [25_39]
             ,[40-54] AS [40_54]
             ,[55-69] AS [55_69]
             ,[70+] AS [70_plus]
             ,[dbo].[CONVERT_DATETIME_TO_UNIX]([DATE_OF_MEASUREMENT]) AS [date_start_unix]
             ,[dbo].[CONVERT_DATETIME_TO_UNIX](DATEADD(day, 6, [DATE_OF_MEASUREMENT])) AS [date_end_unix]
             ,[dbo].[CONVERT_DATETIME_TO_UNIX]([DATE_LAST_INSERTED]) AS [date_of_insertion_unix]
         FROM (
             SELECT
                 [DATE_LAST_INSERTED],
                 [DATE_OF_MEASUREMENT],
                 [SUBGROUP],
                 [INDICATOR_CATEGORY],
                 [INDICATOR],
                 CASE
                     WHEN LOWER([INDICATOR]) = 'werkt_thuis' AND [SUBGROUP] = '70+' THEN NULL
                     ELSE [VALUE]
                 END AS [VALUE]
             FROM
                 [VWSDEST].[BEHAVIOR_NATIONAL_BY_AGE_GROUP] WITH(NOLOCK)
             WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[BEHAVIOR_NATIONAL_BY_AGE_GROUP] WITH(NOLOCK))
             ) SELECT_SOURCE
         PIVOT
             (MAX([VALUE]) -- ONLY ONE VALUE AVAILABLE
             FOR [SUBGROUP] IN ([16-24], [25-39], [40-54], [55-69], [70+])
         ) AS PivotTable
     )
     SELECT 
         [constraint_key],
         [16_24],
         [25_39],
         [40_54],
         [55_69],
         [70_plus],
         [date_start_unix],
         [date_end_unix],
         [date_of_insertion_unix]
     FROM CTE
     WHERE [constraint_key] IS NOT NULL
     UNION
        SELECT DISTINCT
           'selftest_visit_compliance',
           null,
           null,
           NULL,
           null,
           null,
            [date_start_unix],
            [date_end_unix],
            [date_of_insertion_unix]
        FROM CTE
    UNION
     SELECT
        'selftest_visit_support',
        null,
        null,
        NULL,
        null,
        null,
            [date_start_unix],
            [date_end_unix],
            [date_of_insertion_unix]
        FROM CTE