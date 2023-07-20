-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN   VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.
 
 CREATE   PROCEDURE [DBO].[SP_CBS_DECEASED_PER_WEEK]
 AS
 BEGIN
     -- last inserted
     WITH CTE1 AS (
         SELECT 
             [YEAR],
             [WEEK],
             [DECEASED_ACTUAL]
         FROM [VWSINTER].[CBS_DECEASED_PER_WEEK]
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[CBS_DECEASED_PER_WEEK])
     ),
     -- correct week 0's
     CTE2 AS (
         SELECT 
             CASE WHEN [WEEK] = 0 THEN [YEAR] - 1 ELSE [YEAR] END AS [YEAR],
             CASE WHEN [WEEK] = 0 THEN (SELECT MAX([WEEK]) FROM CTE1 a WHERE a.[YEAR] = b.[YEAR] - 1) ELSE [WEEK] END AS [WEEK],
             [DECEASED_ACTUAL]
         FROM CTE1 b
     ),
     -- filter on 2020 and later
     CTE3 AS (
         SELECT
             [YEAR],
             [WEEK],
             [DECEASED_ACTUAL]
         FROM CTE2
         WHERE [YEAR] >= 2020
     ),
     -- sum for every week per year
     CTE4 AS (
         SELECT 
             [YEAR],
             [WEEK],
             SUM([DECEASED_ACTUAL]) AS [DECEASED_ACTUAL]
         FROM CTE3
         GROUP BY [YEAR], [WEEK]
     ),
     -- extra fields (unix)
     CTE5 AS (
         SELECT
             [DBO].[CONVERT_ISO_WEEK_TO_DATETIME]([YEAR], [WEEK]) AS [WEEK_START],
             [DBO].[WEEK_END]([DBO].[CONVERT_ISO_WEEK_TO_DATETIME]([YEAR], [WEEK])) AS [WEEK_END],
             [DBO].[CONVERT_WEEKNUMBER_TO_UNIX]([YEAR], [WEEK]) AS [WEEK_START_UNIX],
             [DBO].[CONVERT_DATETIME_TO_UNIX]([DBO].[WEEK_END]([DBO].[CONVERT_ISO_WEEK_TO_DATETIME]([YEAR], [WEEK]))) AS [WEEK_END_UNIX],
             [YEAR],
             [WEEK],
             [DECEASED_ACTUAL]
         FROM CTE4
     )
     INSERT INTO [VWSDEST].[CBS_DECEASED_PER_WEEK] (
         [WEEK_START],
         [WEEK_END],
         [WEEK_START_UNIX],
         [WEEK_END_UNIX],
         [YEAR],
         [WEEK],
         [DECEASED_ACTUAL],
         [DECEASED_FORECAST],
         [DECEASED_FORECAST_HIGH],
         [DECEASED_FORECAST_LOW]
     )
     SELECT
         T1.[WEEK_START],
         T1.[WEEK_END],
         T1.[WEEK_START_UNIX],
         T1.[WEEK_END_UNIX],
         T1.[YEAR],
         T1.[WEEK],
         T1.[DECEASED_ACTUAL],
         T2.[DECEASED_FORECAST],
         T2.[DECEASED_FORECAST_HIGH],
         T2.[DECEASED_FORECAST_LOW]
     FROM CTE5 AS T1
     LEFT JOIN (
         SELECT 
             [DECEASED_FORECAST],
             [DECEASED_FORECAST_HIGH],
             [DECEASED_FORECAST_LOW],
             [YEAR],
             [WEEK]
         FROM [VWSINTER].[CBS_DECEASED_PER_WEEK_FORECAST]
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[CBS_DECEASED_PER_WEEK_FORECAST])
     ) AS T2
     ON T1.[YEAR]=T2.[YEAR] AND T1.[WEEK]=T2.[WEEK]
 END;