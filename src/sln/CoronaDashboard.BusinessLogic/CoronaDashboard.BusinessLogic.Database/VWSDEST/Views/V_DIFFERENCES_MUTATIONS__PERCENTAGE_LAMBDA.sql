-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
 
 CREATE   VIEW [VWSDEST].[V_DIFFERENCES_MUTATIONS__PERCENTAGE_LAMBDA]
 AS
 WITH BASE_CTE AS (
 SELECT [DATE_START_UNIX]
       ,LAG(DATE_START_UNIX,1) OVER (ORDER BY DATE_START_UNIX) AS OLD_DATE_UNIX
       ,[LAMBDA_PERCENTAGE] AS NEW_VALUE
       ,LAG(LAMBDA_PERCENTAGE,1) OVER (ORDER BY DATE_START_UNIX) AS OLD_VALUE
       ,ROW_NUMBER() OVER (ORDER BY DATE_START_UNIX DESC) AS RANK_DATE
   FROM [VWSDEST].[V_RIVM_MUTATIONS]
   --Date_last_inserted filter is not needed since this is a view on a view.
 )
 SELECT  
      OLD_VALUE
     -- ,NEW_VALUE
     ,ROUND(NEW_VALUE - OLD_VALUE,1) AS [DIFFERENCE]
     ,DATE_START_UNIX AS [NEW_DATE_UNIX]
     ,OLD_DATE_UNIX as [OLD_DATE_UNIX]
 FROM BASE_CTE
   WHERE RANK_DATE = 1 --Only the most recent record