-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 
 CREATE   VIEW [VWSDEST].[V_INHABITANTS_PER_MUNICIPALITY]
 AS
  SELECT Distinct(mun.[GMCODE])
        ,mun.[INHABITANTS] AS POPULATION_COUNT
        ,rwzi.[CONNECTED_INHABITANTS] AS POPULATION_COUNT_CONNECTED_TO_RWZIS
        ,mun.[DATE_LAST_INSERTED]
        ,rwzi.[DATE_LAST_INSERTED] As CONNECTED_INHABITANTS_DATE_LAST_INSERTED
  FROM [VWSSTATIC].[INHABITANTS_PER_MUNICIPALITY] as mun
  JOIN [VWSSTATIC].[RWZI_CONNECTED_INHABITANTS] as rwzi on rwzi.[REGIO_CODE] = mun.[GMCODE]
  WHERE mun.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                              FROM [VWSSTATIC].[INHABITANTS_PER_MUNICIPALITY])
  AND rwzi.[DATE_LAST_INSERTED] = (SELECT MAX(DATE_LAST_INSERTED)
                              FROM [VWSSTATIC].[RWZI_CONNECTED_INHABITANTS])