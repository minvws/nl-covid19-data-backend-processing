-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSREPORT.V_PBI_Reproductiegetal 
AS
-- Veiligheidsregio's
  SELECT 
    CAST([DATE_OF_REPORT] as date)				        AS [Datum]   
    ,CAST([DATE_LAST_INSERTED] as date)     AS [Update datum]   
    ,[REPRODUCTION_INDEX_LOW]						    AS [Reproductiegetal laag]
    ,[REPRODUCTION_INDEX_AVG]						    AS [Reproductiegetal]
    ,[REPRODUCTION_INDEX_HIGH]			    			AS [Reproductiegetal hoog]
  FROM
    [VWSDEST].[REPRODUCTION_NUMBER]
  WHERE
    DATE_OF_REPORT >= CAST('2020-02-17 00:00:00.000' as datetime) AND
    DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[REPRODUCTION_NUMBER])