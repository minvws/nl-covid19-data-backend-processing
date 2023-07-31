-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE    VIEW [VWSDEST].[V_GGD_TESTED_PEOPLE_VR] AS
SELECT 
     [NEW_DATE_OF_REPORT_UNIX]                            AS DATE_UNIX
    ,[REGION_CODE]                                        AS VRCODE
    ,[POSITIVE_TESTS]                                     AS INFECTED
	  ,[7D_AVERAGE_POSITIVE_TESTS]                          AS INFECTED_MOVING_AVERAGE
    ,ISNULL([PERCENTAGE_POSITIVE],0)                      AS INFECTED_PERCENTAGE
	  ,[7D_AVERAGE_PERCENTAGE_POSITIVE]                     AS INFECTED_PERCENTAGE_MOVING_AVERAGE
	  ,[TESTS]                                              AS TESTED_TOTAL
    ,CAST(ROUND([7D_AVERAGE_TESTS], 0) AS INT)            AS TESTED_TOTAL_MOVING_AVERAGE_ROUNDED
	  ,[7D_AVERAGE_TESTS]                                   AS TESTED_TOTAL_MOVING_AVERAGE
    ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)     AS DATE_OF_INSERTION_UNIX
  FROM [VWSDEST].[GGD_TESTED_PEOPLE_VR]
WHERE DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) 
                            FROM [VWSDEST].[GGD_TESTED_PEOPLE_VR])