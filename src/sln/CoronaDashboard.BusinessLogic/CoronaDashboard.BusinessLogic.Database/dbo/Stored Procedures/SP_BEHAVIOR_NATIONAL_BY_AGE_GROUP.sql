-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN   VOLKSGEZONDHEID, WELZIJN EN SPORT. 
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.
 
 -- 1) CREATE STORE PROCEDURE(S) INTER -> DEST.....
 CREATE   PROCEDURE [dbo].[SP_BEHAVIOR_NATIONAL_BY_AGE_GROUP]
 AS
 BEGIN
     WITH RECENT_CTE AS (
         SELECT
             [DATE_OF_REPORT],
             [DATE_OF_MEASUREMENT],
             [WAVE],
             [REGION_CODE],
             [SUBGROUP_CATEGORY],
             [SUBGROUP],
             [INDICATOR_CATEGORY],
             [INDICATOR],
             [FIGURE_TYPE],
             CONVERT(INT, ROUND([VALUE], 0)) AS [VALUE]
         FROM [VWSINTER].[VWS_BEHAVIOR]
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[VWS_BEHAVIOR])
             AND [WAVE] = (SELECT MAX([WAVE]) FROM [VWSINTER].[VWS_BEHAVIOR])
             AND UPPER([REGION_CODE]) LIKE 'NL%'
             AND LOWER([SUBGROUP_CATEGORY]) = 'leeftijd'
             AND [SUBGROUP] IN ('16-24', '25-39', '40-54' , '55-69', '70+')
     ),
     CTE AS (
         SELECT
             ISNULL(T2.[DATE_OF_REPORT],T1.[DATE_OF_REPORT]) AS [DATE_OF_REPORT],
             ISNULL(T2.[DATE_OF_MEASUREMENT],T1.[DATE_OF_MEASUREMENT]) AS [DATE_OF_MEASUREMENT],
             ISNULL(T2.[WAVE],T1.[WAVE]) AS [WAVE],
             ISNULL(T2.[REGION_CODE], T1.[REGION_CODE]) AS [REGION_CODE],
             ISNULL(T2.[SUBGROUP_CATEGORY], T1.[SUBGROUP_CATEGORY]) AS [SUBGROUP_CATEGORY],
             ISNULL(T2.[SUBGROUP], T1.[SUBGROUP]) AS [SUBGROUP],
             ISNULL(T2.[INDICATOR_CATEGORY], 'Draagvlak') AS [INDICATOR_CATEGORY],
             ISNULL(T2.[INDICATOR], T1.[INDICATOR]) AS [INDICATOR],
             ISNULL(T2.[FIGURE_TYPE], T1.[FIGURE_TYPE]) AS [FIGURE_TYPE],
             T2.[VALUE]
         FROM RECENT_CTE AS T1
             LEFT JOIN (
                 SELECT 
                     [DATE_OF_REPORT],
                     [DATE_OF_MEASUREMENT],
                     [WAVE],
                     [REGION_CODE],
                     [SUBGROUP_CATEGORY],
                     [SUBGROUP],
                     [INDICATOR_CATEGORY],
                     [INDICATOR],
                     [FIGURE_TYPE],
                     [VALUE]
                 FROM RECENT_CTE 
                 WHERE LOWER([INDICATOR_CATEGORY]) = 'draagvlak'
             ) T2 ON T1.[DATE_OF_MEASUREMENT] = T2.[DATE_OF_MEASUREMENT] AND T1.[INDICATOR] = T2.[INDICATOR]
         WHERE LOWER(T1.[INDICATOR_CATEGORY]) = 'naleving'
         UNION
         SELECT
             [DATE_OF_REPORT],
             [DATE_OF_MEASUREMENT],
             [WAVE],
             [REGION_CODE],
             [SUBGROUP_CATEGORY],
             [SUBGROUP],
             [INDICATOR_CATEGORY],
             [INDICATOR],
             [FIGURE_TYPE],
             [VALUE]
         FROM RECENT_CTE
         WHERE LOWER([INDICATOR_CATEGORY]) IN ('draagvlak', 'naleving')
     )
     INSERT INTO [VWSDEST].[BEHAVIOR_NATIONAL_BY_AGE_GROUP] (
         [DATE_OF_REPORT],
         [DATE_OF_MEASUREMENT],
         [WAVE],
         [REGION_CODE],
         [SUBGROUP_CATEGORY],
         [SUBGROUP],
         [INDICATOR_CATEGORY],
         [INDICATOR],
         [FIGURE_TYPE],
         [VALUE]
     )
     SELECT 
         [DATE_OF_REPORT],
         [DATE_OF_MEASUREMENT],
         [WAVE],
         [REGION_CODE],
         [SUBGROUP_CATEGORY],
         [SUBGROUP],
         [INDICATOR_CATEGORY],
         [INDICATOR],
         [FIGURE_TYPE],
         [VALUE]
     FROM CTE
 END;