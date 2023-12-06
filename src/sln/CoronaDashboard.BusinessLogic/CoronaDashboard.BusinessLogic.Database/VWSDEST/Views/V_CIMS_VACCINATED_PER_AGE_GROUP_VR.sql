﻿-- 1) CREATE VIEW(S)....
 CREATE   VIEW [VWSDEST].[V_CIMS_VACCINATED_PER_AGE_GROUP_VR] 
 AS
     WITH CAMPAIGN_CTE AS (
         SELECT
             [REGION_CODE] AS [VRCODE],
             [DBO].[CONVERT_DATETIME_TO_UNIX]([DATE_OF_STATISTICS]) AS [DATE_UNIX],            
             [DBO].[CONVERT_DATETIME_TO_UNIX]([DATE_LAST_INSERTED]) AS [DATE_OF_INSERTION_UNIX],
             [DBO].[CONVERT_DATETIME_TO_UNIX]([DATE_OF_REPORT])     AS [DATE_OF_REPORT_UNIX],
             [PERCENTAGE] AS [VACCINATED_PERCENTAGE],
             [PERCENTAGE_LABEL] AS [VACCINATED_PERCENTAGE_LABEL],
             [AGE_GROUP],
             [BIRTHYEAR_RANGE]
         FROM [VWSDEST].[CIMS_VACCINATED_PER_AGE_GROUP_CAMPAIGN_GM_VR] WITH(NOLOCK)
         WHERE [REGION_CODE] LIKE 'VR%'
             AND [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[CIMS_VACCINATED_PER_AGE_GROUP_CAMPAIGN_GM_VR] WITH(NOLOCK))
             AND UPPER([VACCINATION_CAMPAIGN]) IN ('202209_CAMPAIGN')
     ),
     CAMPAIGN_FILTERED_CTE AS (
         SELECT 
             T2.[VRCODE],
             [VACCINATED_PERCENTAGE], 
             [VACCINATED_PERCENTAGE_LABEL],
             [DATE_OF_INSERTION_UNIX],
             T1.[DATE_OF_REPORT_UNIX],
             T2.[DATE_UNIX],
             [AGE_GROUP] AS [AGE_GROUP_RANGE],
             T1.[BIRTHYEAR_RANGE]
         FROM CAMPAIGN_CTE T1
         INNER JOIN (
         SELECT
             MAX([DATE_UNIX]) AS [DATE_UNIX],
             [VRCODE]
         FROM CAMPAIGN_CTE
         GROUP BY [VRCODE]
         ) AS T2 ON T1.[VRCODE] = T2.[VRCODE] AND T1.[DATE_UNIX] = T2.[DATE_UNIX]
     ),
     CTE AS (
         SELECT
             dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_REPORT)                     AS DATE_OF_REPORT_UNIX,
             dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_STATISTICS)                 AS DATE_UNIX,
             [REGION_CODE]                                                    AS VRCODE,
             AGE_GROUP                                                        AS AGE_GROUP_RANGE,
             [BIRTH_YEAR]                                                     AS BIRTHYEAR_RANGE,
             [PERCENTAGE]                                                     AS VACCINATED_PERCENTAGE,
             [PERCENTAGE_LABEL]                                               AS VACCINATED_PERCENTAGE_LABEL,
             dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)                 AS DATE_OF_INSERTION_UNIX
         FROM VWSDEST.CIMS_VACCINATED_PER_AGE_GROUP_GM_VR WITH(NOLOCK)
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM VWSDEST.CIMS_VACCINATED_PER_AGE_GROUP_GM_VR WITH(NOLOCK))
             AND [VACCINATION_SERIE] = 'Primary_series_completed'
             AND REGION_CODE LIKE 'VR%'
     ),
     VR_CODES_CTE AS (
         SELECT DISTINCT [VRCODE] FROM CTE
     ),
     VR_CODES_CAMPAIGN AS (
         SELECT DISTINCT [VRCODE] FROM CTE
     )
     SELECT
         T2.[DATE_UNIX],
         T2.[VRCODE],
         'primary_series' AS [VACCINATION_TYPE],
         T3.[BIRTHYEAR_RANGE] AS [BIRTHYEAR_RANGE_12_PLUS],
         T4.[BIRTHYEAR_RANGE] AS [BIRTHYEAR_RANGE_18_PLUS],
         T5.[BIRTHYEAR_RANGE] AS [BIRTHYEAR_RANGE_60_PLUS],
         CAST(ROUND(T3.[VACCINATED_PERCENTAGE], 0) AS INT) AS [VACCINATED_PERCENTAGE_12_PLUS],
         T3.[VACCINATED_PERCENTAGE_LABEL] AS [VACCINATED_PERCENTAGE_12_PLUS_LABEL],
         CAST(ROUND(T4.[VACCINATED_PERCENTAGE], 0) AS INT) AS [VACCINATED_PERCENTAGE_18_PLUS],
         T4.[VACCINATED_PERCENTAGE_LABEL] AS [VACCINATED_PERCENTAGE_18_PLUS_LABEL],
         CAST(ROUND(T5.[VACCINATED_PERCENTAGE], 0) AS INT) AS [VACCINATED_PERCENTAGE_60_PLUS],
         T5.[VACCINATED_PERCENTAGE_LABEL] AS [VACCINATED_PERCENTAGE_60_PLUS_LABEL],
         T2.[DATE_OF_INSERTION_UNIX]
     FROM VR_CODES_CTE T1
     JOIN CTE T2 ON T1.[VRCODE] = T2.[VRCODE]
     LEFT JOIN CTE T3 ON T1.[VRCODE] = T3.[VRCODE] AND T3.[AGE_GROUP_RANGE] = '12+'
     LEFT JOIN CTE T4 ON T1.[VRCODE] = T4.[VRCODE] AND T4.[AGE_GROUP_RANGE] = '18+'
     LEFT JOIN CTE T5 ON T1.[VRCODE] = T5.[VRCODE] AND T5.[AGE_GROUP_RANGE] = '60+'
         UNION
     SELECT
         T2.[DATE_UNIX],
         T2.[VRCODE],
         'autumn_2022' AS [VACCINATION_TYPE],
         T3.[BIRTHYEAR_RANGE] AS [BIRTHYEAR_RANGE_12_PLUS],
         T4.[BIRTHYEAR_RANGE] AS [BIRTHYEAR_RANGE_18_PLUS],
         T5.[BIRTHYEAR_RANGE] AS [BIRTHYEAR_RANGE_60_PLUS],
         CAST(ROUND(T3.[VACCINATED_PERCENTAGE], 0) AS INT) AS [VACCINATED_PERCENTAGE_12_PLUS],
         T3.[VACCINATED_PERCENTAGE_LABEL] AS [VACCINATED_PERCENTAGE_12_PLUS_LABEL],
         CAST(ROUND(T4.[VACCINATED_PERCENTAGE], 0) AS INT) AS [VACCINATED_PERCENTAGE_18_PLUS],
         T4.[VACCINATED_PERCENTAGE_LABEL] AS [VACCINATED_PERCENTAGE_18_PLUS_LABEL],
         CAST(ROUND(T5.[VACCINATED_PERCENTAGE], 0) AS INT) AS [VACCINATED_PERCENTAGE_60_PLUS],
         T5.[VACCINATED_PERCENTAGE_LABEL] AS [VACCINATED_PERCENTAGE_60_PLUS_LABEL],
         T2.[DATE_OF_INSERTION_UNIX]
     FROM VR_CODES_CAMPAIGN T1
     JOIN CAMPAIGN_FILTERED_CTE T2 ON T1.[VRCODE] = T2.[VRCODE]
     LEFT JOIN CAMPAIGN_FILTERED_CTE T3 ON T1.[VRCODE] = T3.[VRCODE] AND T3.[AGE_GROUP_RANGE] = '12+'
     LEFT JOIN CAMPAIGN_FILTERED_CTE T4 ON T1.[VRCODE] = T4.[VRCODE] AND T4.[AGE_GROUP_RANGE] = '18+'
     LEFT JOIN CAMPAIGN_FILTERED_CTE T5 ON T1.[VRCODE] = T5.[VRCODE] AND T5.[AGE_GROUP_RANGE] = '60+'