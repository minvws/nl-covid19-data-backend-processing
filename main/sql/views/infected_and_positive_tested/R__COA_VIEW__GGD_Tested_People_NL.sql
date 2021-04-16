-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER VIEW VWSDEST.V_GGD_TESTED_PEOPLE_NL AS
SELECT 
       [NEW_DATE_OF_REPORT_UNIX] AS DATE_UNIX
      ,[TESTS] AS TESTED_TOTAL
      ,[POSITIVE_TESTS] AS INFECTED
      ,[PERCENTAGE_POSITIVE] AS INFECTED_PERCENTAGE
      ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
  FROM [VWSDEST].[GGD_TESTED_PEOPLE_NL]
WHERE DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) 
                            FROM [VWSDEST].[GGD_TESTED_PEOPLE_NL])