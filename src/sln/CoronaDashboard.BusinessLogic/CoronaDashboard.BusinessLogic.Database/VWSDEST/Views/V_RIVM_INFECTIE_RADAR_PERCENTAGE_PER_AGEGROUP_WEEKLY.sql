﻿CREATE VIEW [VWSDEST].[V_RIVM_INFECTIE_RADAR_PERCENTAGE_PER_AGEGROUP_WEEKLY] AS
WITH CTE AS (
    SELECT
	    [DATE_LAST_INSERTED],
		[DATE_OF_REPORT],
		[DATE_OF_STATISTICS_WEEK_END],
		[AGE_GROUPS],
		[PERC_COVID_SYMPTOMS]
    FROM [VWSDEST].[RIVM_INFECTIE_RADAR_PERCENTAGE_PER_AGEGROUP_WEEKLY]
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_INFECTIE_RADAR_PERCENTAGE_PER_AGEGROUP_WEEKLY])
),
CTE2 AS (
    SELECT
	    [DATE_LAST_INSERTED],
		[DATE_OF_REPORT],
		[DATE_OF_STATISTICS_WEEK_END],
		[AGE_GROUPS],
		[PERC_COVID_SYMPTOMS]
    FROM CTE
    WHERE [DATE_OF_REPORT] = (SELECT MAX([DATE_OF_REPORT]) FROM CTE)
),
DATES_OF_STATISTICS AS (
    SELECT DISTINCT
	    [DATE_LAST_INSERTED],
		[DATE_OF_REPORT],
		[DATE_OF_STATISTICS_WEEK_END]
    FROM CTE2
)
SELECT
    [dbo].[CONVERT_DATETIME_TO_UNIX](a.[DATE_LAST_INSERTED]) AS [DATE_OF_INSERTION_UNIX],
	[dbo].[CONVERT_DATETIME_TO_UNIX](a.[DATE_OF_REPORT]) AS [DATE_OF_REPORT_UNIX],
	[dbo].[CONVERT_DATETIME_TO_UNIX](dateadd(day, -6,  [dbo].[WEEK_START_ISO](a.[DATE_OF_STATISTICS_WEEK_END]))) AS [DATE_START_UNIX],
    [dbo].[CONVERT_DATETIME_TO_UNIX]([dbo].[WEEK_START_ISO](a.[DATE_OF_STATISTICS_WEEK_END])) AS [DATE_END_UNIX],
	b.[PERC_COVID_SYMPTOMS] AS [PERCENTAGE_0_24],
	c.[PERC_COVID_SYMPTOMS] AS [PERCENTAGE_25_39],
	d.[PERC_COVID_SYMPTOMS] AS [PERCENTAGE_40_49],
	e.[PERC_COVID_SYMPTOMS] AS [PERCENTAGE_50_59],
	f.[PERC_COVID_SYMPTOMS] AS [PERCENTAGE_60_69],
	g.[PERC_COVID_SYMPTOMS] AS [PERCENTAGE_70_PLUS],
	h.[PERC_COVID_SYMPTOMS] AS [PERCENTAGE_AVERAGE]
FROM DATES_OF_STATISTICS a
LEFT JOIN CTE2 b ON a.[DATE_LAST_INSERTED] = b.[DATE_LAST_INSERTED] AND a.[DATE_OF_REPORT] = b.[DATE_OF_REPORT] AND a.[DATE_OF_STATISTICS_WEEK_END] = b.[DATE_OF_STATISTICS_WEEK_END]
AND b.[AGE_GROUPS] = '<=24'
LEFT JOIN CTE2 c ON a.[DATE_LAST_INSERTED] = c.[DATE_LAST_INSERTED] AND a.[DATE_OF_REPORT] = c.[DATE_OF_REPORT] AND a.[DATE_OF_STATISTICS_WEEK_END] = c.[DATE_OF_STATISTICS_WEEK_END]
AND c.[AGE_GROUPS] = '25-39'
LEFT JOIN CTE2 d ON a.[DATE_LAST_INSERTED] = d.[DATE_LAST_INSERTED] AND a.[DATE_OF_REPORT] = d.[DATE_OF_REPORT] AND a.[DATE_OF_STATISTICS_WEEK_END] = d.[DATE_OF_STATISTICS_WEEK_END]
AND d.[AGE_GROUPS] = '40-49'
LEFT JOIN CTE2 e ON a.[DATE_LAST_INSERTED] = e.[DATE_LAST_INSERTED] AND a.[DATE_OF_REPORT] = e.[DATE_OF_REPORT] AND a.[DATE_OF_STATISTICS_WEEK_END] = e.[DATE_OF_STATISTICS_WEEK_END]
AND e.[AGE_GROUPS] = '50-59'
LEFT JOIN CTE2 f ON a.[DATE_LAST_INSERTED] = f.[DATE_LAST_INSERTED] AND a.[DATE_OF_REPORT] = f.[DATE_OF_REPORT] AND a.[DATE_OF_STATISTICS_WEEK_END] = f.[DATE_OF_STATISTICS_WEEK_END]
AND f.[AGE_GROUPS] = '60-69'
LEFT JOIN CTE2 g ON a.[DATE_LAST_INSERTED] = g.[DATE_LAST_INSERTED] AND a.[DATE_OF_REPORT] = g.[DATE_OF_REPORT] AND a.[DATE_OF_STATISTICS_WEEK_END] = g.[DATE_OF_STATISTICS_WEEK_END]
AND g.[AGE_GROUPS] = '70+'
LEFT JOIN CTE2 h ON a.[DATE_LAST_INSERTED] = h.[DATE_LAST_INSERTED] AND a.[DATE_OF_REPORT] = h.[DATE_OF_REPORT] AND a.[DATE_OF_STATISTICS_WEEK_END] = h.[DATE_OF_STATISTICS_WEEK_END]
AND h.[AGE_GROUPS] = 'Totaal'
GO