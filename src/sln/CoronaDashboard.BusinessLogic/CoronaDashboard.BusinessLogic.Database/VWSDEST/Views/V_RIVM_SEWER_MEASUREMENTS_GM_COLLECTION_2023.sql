-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   VIEW [VWSDEST].[V_RIVM_SEWER_MEASUREMENTS_GM_COLLECTION_2023] AS
     WITH CTE1 AS (
         SELECT
         [GMCODE],
         [DATE_START_UNIX],
         [DATE_END_UNIX],
         [AVERAGE],
         [DATA_IS_OUTDATED],
         [DATE_OF_INSERTION_UNIX]
         FROM [VWSDEST].[V_RIVM_SEWER_MEASUREMENTS_GM_2023]
     ),
     CTE2 AS 
     (
         SELECT [GMCODE], MAX([DATE_START_UNIX]) AS MAX_DATE
         FROM CTE1
         GROUP BY [GMCODE]
     )
     SELECT
         CTE1.[GMCODE],
         CTE1.[DATE_START_UNIX],
         CTE1.[DATE_END_UNIX],
         CTE1.[AVERAGE],
         CTE1.[DATA_IS_OUTDATED],
         CTE1.[DATE_OF_INSERTION_UNIX]
     FROM CTE1
     JOIN CTE2 ON CTE1.[GMCODE] = CTE2.[GMCODE] AND CTE1.[DATE_START_UNIX] = CTE2.MAX_DATE -- only take last values per municipality