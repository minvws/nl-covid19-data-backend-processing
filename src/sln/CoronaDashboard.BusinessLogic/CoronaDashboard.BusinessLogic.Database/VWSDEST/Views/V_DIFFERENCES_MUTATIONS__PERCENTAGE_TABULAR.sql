-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
 
 --File name has _A_ to make sure this file is executed before the view that depends on this.
 CREATE    VIEW [VWSDEST].[V_DIFFERENCES_MUTATIONS__PERCENTAGE_TABULAR]
 AS
 WITH BASE_CTE AS 
 (
     SELECT [DATE_START_UNIX]
       ,LAG(DATE_START_UNIX,1) OVER (PARTITION BY [VARIANT_CODE] ORDER BY DATE_START_UNIX) AS OLD_DATE_UNIX
       ,[PERCENTAGE] AS NEW_VALUE
       ,[VARIANT_CODE]
       ,LAG([PERCENTAGE],1) OVER (PARTITION BY [VARIANT_CODE] ORDER BY DATE_START_UNIX) AS OLD_VALUE
       ,ROW_NUMBER() OVER (PARTITION BY [VARIANT_CODE] ORDER BY DATE_START_UNIX DESC) AS RANK_DATE
     FROM [VWSDEST].[V_RIVM_MUTATIONS_TABULAR]
 )
 SELECT  
     REPLACE([VARIANT_CODE], '.', '_') AS [VARIANT_CODE]
     ,OLD_VALUE
     -- ,NEW_VALUE
     ,ROUND(NEW_VALUE - OLD_VALUE,1) AS [DIFFERENCE]
     ,DATE_START_UNIX AS [NEW_DATE_UNIX]
     ,OLD_DATE_UNIX as [OLD_DATE_UNIX]
 FROM BASE_CTE
   WHERE RANK_DATE = 1 --Only the most recent record
   AND (OLD_VALUE <> 0 OR NEW_VALUE <> 0) -- only cases where there is data present
