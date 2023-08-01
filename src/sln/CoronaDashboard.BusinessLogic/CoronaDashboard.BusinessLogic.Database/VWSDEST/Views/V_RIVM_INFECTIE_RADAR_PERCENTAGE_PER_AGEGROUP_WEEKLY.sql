﻿CREATE VIEW [VWSREPORT].[V_RIVM_INFECTIE_RADAR_PERCENTAGE_PER_AGEGROUP_WEEKLY] AS
WITH CTE AS (
    SELECT
        [DATE_OF_REPORT],
        [dbo].[CONVERT_DATETIME_TO_UNIX](dateadd(day, -6,  [dbo].[WEEK_START_ISO]([DATE_OF_STATISTICS_WEEK_END]))) AS [DATE_START_UNIX],
        [dbo].[CONVERT_DATETIME_TO_UNIX]([dbo].[WEEK_START_ISO]([DATE_OF_STATISTICS_WEEK_END])) AS [DATE_END_UNIX],
        [AGE_GROUPS],
        [PERC_COVID_SYMPTOMS]
    FROM [VWSDEST].[RIVM_INFECTIE_RADAR_PERCENTAGE_PER_AGEGROUP_WEEKLY] WITH(NOLOCK)
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_INFECTIE_RADAR_PERCENTAGE_PER_AGEGROUP_WEEKLY] WITH(NOLOCK))
)
SELECT
    *
FROM CTE
GO