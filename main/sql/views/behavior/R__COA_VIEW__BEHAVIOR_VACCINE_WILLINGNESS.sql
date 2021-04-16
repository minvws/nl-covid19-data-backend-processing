-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER  VIEW [VWSDEST].[V_BEHAVIOR_VACCINE_WILLINGNESS]
AS
SELECT 
       [VACCINE_WILLINGNESS] * 100   AS [PERCENTAGE_IN_FAVOR]
      ,VACCINATED * 100            AS [PERCENTAGE_ALREADY_VACCINATED]
      ,[DATE_START_UNIX]
      ,[DATE_END_UNIX]
      ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM [VWSDEST].[BEHAVIOR_VACCINE_WILLINGNESS]
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM [VWSDEST].[BEHAVIOR_VACCINE_WILLINGNESS])
;