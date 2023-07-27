-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   VIEW VWSREPORT.V_PBI_Positieve_testen_per_leeftijdsgroep AS   
SELECT 
       [AGEGROUP]                             AS [Leeftijdsgroep]
      ,[DATE]                                 AS [Datum]
      ,CAST([DATE_LAST_INSERTED] as date)     AS [Update datum]
      ,[DATE_UNIX]                            AS [Datum Unix]
      ,[CASES_7D_MOVING_AVERAGE]              AS [Positieve testen (7d gem)]
      ,[CASES_7D_MOVING_AVERAGE_100K]         AS [Positieve testen (7d gem per 100 K)]
      ,[CASES]                                AS [Positieve testen]
  FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME]

  WHERE 
    DATE_LAST_INSERTED = 
        (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME])
  AND AGEGROUP <> 'Total'