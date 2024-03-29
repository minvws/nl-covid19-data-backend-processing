﻿-- 1) CREATE VIEW(S).....
 CREATE   VIEW [VWSDEST].[V_RIVM_VACCINE_ADMINISTERED_LAST_TIMEFRAME_NL] AS
 
 WITH CTE AS (
     SELECT
         [DATE_OF_REPORT],
         [DATE_FIRST_DAY],
         [VALUE_NAME] AS [VACCINE_TYPE_NAME],
         [VALUE] AS [VACCINE_TYPE_VALUE],
         [DATE_LAST_INSERTED]
     FROM [VWSDEST].[RIVM_VACCINE_ADMINISTERED_LAST_WEEK_NL] WITH(NOLOCK)
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_VACCINE_ADMINISTERED_LAST_WEEK_NL] WITH(NOLOCK))
 ),
 CTE2 AS (
     SELECT a.[DATE_OF_REPORT], a.[DATE_FIRST_DAY], a.[VACCINE_TYPE_NAME], a.[VACCINE_TYPE_VALUE], a.[DATE_LAST_INSERTED], SUM(b.[VACCINE_TYPE_VALUE]) AS [VACCINE_TYPE_VALUE_TIMEFRAME]
     FROM CTE a
     JOIN CTE b
     ON a.VACCINE_TYPE_NAME = b.VACCINE_TYPE_NAME
     AND b.DATE_FIRST_DAY <= a.DATE_FIRST_DAY -- smaller or equal than a
     AND b.DATE_FIRST_DAY > DATEADD(DAY, -7, a.DATE_FIRST_DAY) -- bigger than 1 week ago
     GROUP BY a.[DATE_OF_REPORT], a.[DATE_FIRST_DAY], a.[VACCINE_TYPE_NAME], a.[VACCINE_TYPE_VALUE], a.[DATE_LAST_INSERTED]
 ),
 CTE3 AS (
     SELECT
         [DATE_OF_REPORT],
         [DATE_FIRST_DAY],
         [dbo].[CONVERT_DATETIME_TO_UNIX]([DATE_OF_REPORT]) AS [DATE_UNIX],
         [dbo].[CONVERT_DATETIME_TO_UNIX]([DATE_FIRST_DAY]) AS [DATE_START_UNIX], -- 0 weeks before last week
         [dbo].[CONVERT_DATETIME_TO_UNIX](DATEADD(DAY, 6, [DATE_FIRST_DAY])) AS [DATE_END_UNIX], -- 6 days later (sunday)
         [dbo].[CONVERT_DATETIME_TO_UNIX]([DATE_LAST_INSERTED]) AS [DATE_OF_INSERTION_UNIX],
         [VACCINE_TYPE_NAME],
         [VACCINE_TYPE_VALUE_TIMEFRAME]
     FROM CTE2
 )
 SELECT 
     [DATE_UNIX],
     [DATE_START_UNIX],
     [DATE_END_UNIX],
     [DATE_OF_INSERTION_UNIX],
     [VACCINE_TYPE_NAME],
     [VACCINE_TYPE_VALUE_TIMEFRAME] AS [VACCINE_TYPE_VALUE]
 FROM CTE3
 WHERE [DATE_START_UNIX] = ( -- last week with data
     SELECT MAX([DATE_START_UNIX]) 
     FROM CTE3
     WHERE [DATE_END_UNIX] < ([dbo].[CONVERT_DATETIME_TO_UNIX](DATE_OF_REPORT)) -- make sure the date of report is ahead of DATE_END_UNIX
 )
 AND [VACCINE_TYPE_NAME] <> 'unknown'