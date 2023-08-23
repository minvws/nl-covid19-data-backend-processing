﻿ --1) CREATE VIEW(S).....
 CREATE   VIEW [VWSREPORT].[V_RIVM_INFECTIE_RADAR_TREND_PER_LEEFTIJD_WEEKLY] AS
 WITH CTE AS (
     SELECT
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS_WEEK_END],
         [AGE_GROUPS],
         [N_PARTICIPANTS],
         [PERC_COVID_SYMPTOMS],
         [DATE_LAST_INSERTED]
     FROM [VWSDEST].[RIVM_INFECTIE_RADAR_PERCENTAGE_PER_AGEGROUP_WEEKLY] WITH(NOLOCK)
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_INFECTIE_RADAR_PERCENTAGE_PER_AGEGROUP_WEEKLY] WITH(NOLOCK))
 )
 SELECT
     *
 FROM CTE
 GO