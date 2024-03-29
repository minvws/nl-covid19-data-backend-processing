﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN   VOLKSGEZONDHEID, WELZIJN EN SPORT. 
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.
 
 CREATE   VIEW [VWSDEST].[V_POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY] 
 AS
     SELECT 
         [DATE_OF_REPORT_UNIX] AS [DATE_UNIX],
         [MUNICIPALITY_CODE] AS [GMCODE],
         [MUNICIPALITY_NAME],
         [DBO].[NO_NEGATIVE_NUMBER_F]([INFECTED_DAILY_TOTAL]) AS [INFECTED],
         [DBO].[NO_NEGATIVE_NUMBER_F]([INFECTED_DAILY_INCREASE]) AS [INFECTED_PER_100K],
         CAST(ROUND([7D_AVERAGE_INFECTED_DAILY_INCREASE_TOTAL], 1) AS DECIMAL (16,1)) AS [INFECTED_PER_100K_MOVING_AVERAGE],
         CAST([7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE] AS DECIMAL (16,1)) AS [INFECTED_MOVING_AVERAGE],
         CAST(ROUND([7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE],0) AS INT) AS [INFECTED_MOVING_AVERAGE_ROUNDED],
         [DBO].[CONVERT_DATETIME_TO_UNIX]([DATE_LAST_INSERTED]) AS [DATE_OF_INSERTION_UNIX]
     FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY]
     WHERE [DATE_OF_REPORT] >= '2020-03-02 00:00:00.000'
     AND [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) 
                                 FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY]);