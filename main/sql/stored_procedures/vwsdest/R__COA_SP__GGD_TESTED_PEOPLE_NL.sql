-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_GGD_TESTED_PEOPLE_NL
AS
BEGIN

INSERT INTO VWSDEST.GGD_TESTED_PEOPLE_NL
    (
       [DATE_OF_STATISTICS]
      ,[DATE_RANGE_START]
      ,[DATE_OF_STATISTICS_LAG]
      ,[DATE_RANGE_START_LAG]
      ,NEW_DATE_OF_REPORT_UNIX
      ,DATE_RANGE_START_UNIX
      ,OLD_DATE_OF_REPORT_UNIX
--      ,[REGION_CODE]
--      ,[REGION_NAME]
      ,[TESTS]
      ,[POSITIVE_TESTS]
      ,[PERCENTAGE_POSITIVE]
      ,[7D_AVERAGE_TESTS]
      ,[7D_AVERAGE_TESTS_LAG]
      ,[7D_AVERAGE_TESTS_DIFF]
      ,[7D_AVERAGE_POSITIVE_TESTS]
      ,[7D_AVERAGE_POSITIVE_TESTS_LAG]
      ,[7D_AVERAGE_POSITIVE_TESTS_DIFF]
      ,[7D_AVERAGE_PERCENTAGE_POSITIVE]
      ,[7D_AVERAGE_PERCENTAGE_POSITIVE_LAG]
      ,[7D_AVERAGE_PERCENTAGE_POSITIVE_DIFF]
    )
SELECT  
       [DATE_OF_STATISTICS]
      ,[DATE_RANGE_START]
      ,[DATE_OF_STATISTICS_LAG]
      ,[DATE_RANGE_START_LAG]
      ,NEW_DATE_OF_REPORT_UNIX
      ,DATE_RANGE_START_UNIX
      ,OLD_DATE_OF_REPORT_UNIX
--      ,[REGION_CODE]
--      ,[REGION_NAME]
      ,[TESTS]
      ,[POSITIVE_TESTS]
      ,[PERCENTAGE_POSITIVE]
      ,[7D_AVERAGE_TESTS]
      ,[7D_AVERAGE_TESTS_LAG]
      ,[7D_AVERAGE_TESTS_DIFF]
      ,[7D_AVERAGE_POSITIVE_TESTS]
      ,[7D_AVERAGE_POSITIVE_TESTS_LAG]
      ,[7D_AVERAGE_POSITIVE_TESTS_DIFF]
      ,[7D_AVERAGE_PERCENTAGE_POSITIVE]
      ,[7D_AVERAGE_PERCENTAGE_POSITIVE_LAG]
      ,[7D_AVERAGE_PERCENTAGE_POSITIVE_DIFF]
  FROM [VWSDEST].[GGD_TESTED_PEOPLE_BASE]
  WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[GGD_TESTED_PEOPLE_BASE])
  AND LEFT(REGION_CODE,2) = 'NL'

END;