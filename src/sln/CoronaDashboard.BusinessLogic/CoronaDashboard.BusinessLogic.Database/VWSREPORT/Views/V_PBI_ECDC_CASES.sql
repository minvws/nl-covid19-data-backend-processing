-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   VIEW VWSREPORT.V_PBI_ECDC_CASES AS
WITH NL_CTE AS (
SELECT 
       'Netherlands-RIVM'               AS [Land]
      ,'NLD-RIVM'                       AS [Land code]
      ,[POPULATION]                     AS [Populatie]
      ,[WEEK_START]                     AS [Week begin]
      ,[WEEK_END]                       AS [Week eind]
      ,[TOT_INFECTED]                   AS [Geinfecteerd]
      ,ROUND([TOT_INFECTED_RATE] ,1)    AS [Geinfecteerd totaal gemiddeld]
      ,ROUND([REL_INFECTED]      ,1)    AS [Geinfecteerd per 100K]
      ,ROUND([REL_INFECTED_RATE] ,1)    AS [Geinfecteerd per 100K gemiddeld]
      ,[DATE_LAST_INSERTED]             AS [Update datum]
  FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE_WEEKLY]
  WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE_WEEKLY])
)
,
INTERNATIONAL_CTE AS (
SELECT 

       COUNTRY                              AS [Land]
      ,COUNTRY_CODE                         AS [Land code]
      ,POPULATION                           AS [Populatie]
      ,[WEEK_START]                         AS [Week begin]
      ,[WEEK_END]                           AS [Week eind]
      ,[INFECTED_TOTAL]                     AS [Geinfecteerd]
      ,ROUND([INFECTED_TOTAL_AVERAGE],1)    AS [Geinfecteerd totaal gemiddeld]
      ,ROUND([INFECTED_PER_100K],1)         AS [Geinfecteerd per 100K]
      ,ROUND([INFECTED_PER_100K_AVERAGE],1) AS [Geinfecteerd per 100K gemiddeld]
      ,[DATE_LAST_INSERTED]                 AS [Update datum]
  FROM [VWSDEST].[ECDC_CASES]
  WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[ECDC_CASES])
)
,
--Select all rows
COMBINED_CTE AS (
        SELECT * FROM NL_CTE
        UNION ALL 
        SELECT * FROM INTERNATIONAL_CTE
)

SELECT *
FROM COMBINED_CTE
--Make sure the last dates of NL and international are aligned
WHERE [Week eind] <= (SELECT MAX([Week eind]) FROM NL_CTE)
  AND [Week eind] <= (SELECT MAX([Week eind]) FROM INTERNATIONAL_CTE)