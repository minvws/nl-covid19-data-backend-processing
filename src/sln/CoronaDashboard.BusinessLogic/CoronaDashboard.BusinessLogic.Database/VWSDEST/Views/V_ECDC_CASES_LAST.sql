-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.


CREATE   VIEW VWSDEST.V_ECDC_CASES_LAST AS
SELECT 
       [COUNTRY]
      ,[COUNTRY_CODE]
      ,[POPULATION]
      ,[DATE_START_UNIX]
      ,[DATE_END_UNIX]
      ,[INFECTED]
      ,[INFECTED_TOTAL_AVERAGE]
      ,[INFECTED_PER_100K]
      ,[INFECTED_PER_100K_AVERAGE]
      ,[DATE_OF_INSERTION_UNIX]
FROM VWSDEST.V_ECDC_CASES
  WHERE DATE_END_UNIX = (SELECT MAX(DATE_END_UNIX) FROM VWSDEST.V_ECDC_CASES)