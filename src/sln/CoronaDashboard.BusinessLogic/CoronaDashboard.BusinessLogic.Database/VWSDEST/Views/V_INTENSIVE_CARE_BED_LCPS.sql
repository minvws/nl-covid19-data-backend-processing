-- UNION VIEW
 
 -- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   VIEW [VWSDEST].[V_INTENSIVE_CARE_BED_LCPS] AS
     WITH BASE_CTE AS (
         SELECT * FROM [VWSDEST].[V_INTENSIVE_CARE_BED_LCPS_2023] WHERE DATE_UNIX >= dbo.CONVERT_DATETIME_TO_UNIX('2022-12-12')
         UNION
         SELECT * FROM [VWSDEST].[V_IC_BED_OCCUPANCY] WHERE DATE_UNIX < dbo.CONVERT_DATETIME_TO_UNIX('2022-12-12')
     )
     SELECT
         t1.[DATE_UNIX],
         t1.[BEDS_OCCUPIED_COVID],
         --t1.[BEDS_OCCUPIED_NON_COVID], -- removed on request of FE(See: COR-1275)
         t1.[BEDS_OCCUPIED_COVID_PERCENTAGE],
         t1.[INFLUX_COVID_PATIENTS],
         CAST(AVG(CAST(t2.[INFLUX_COVID_PATIENTS] AS FLOAT)) AS DECIMAL(16,2)) AS [INFLUX_COVID_PATIENTS_MOVING_AVERAGE],
         t1.[DATE_OF_INSERTION_UNIX]
     FROM BASE_CTE t1
     LEFT OUTER JOIN BASE_CTE t2 
         ON
         dbo.CONVERT_UNIX_TO_DATETIME(t2.[DATE_UNIX])
         BETWEEN
         dateadd(day,-6,dbo.CONVERT_UNIX_TO_DATETIME(t1.[DATE_UNIX]))
         AND
         dbo.CONVERT_UNIX_TO_DATETIME(t1.[DATE_UNIX])
     GROUP BY 
         t1.[DATE_UNIX],
         t1.[BEDS_OCCUPIED_COVID],
         --t1.[BEDS_OCCUPIED_NON_COVID], -- removed on request of FE(See: COR-1275)
         t1.[BEDS_OCCUPIED_COVID_PERCENTAGE],
         t1.[INFLUX_COVID_PATIENTS],
         t1.[DATE_OF_INSERTION_UNIX]