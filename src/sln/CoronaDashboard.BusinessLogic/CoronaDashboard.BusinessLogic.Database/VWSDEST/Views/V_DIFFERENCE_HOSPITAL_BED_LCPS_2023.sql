﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   VIEW [VWSDEST].[V_DIFFERENCE_HOSPITAL_BED_LCPS_2023] AS
 
 WITH LAST_DATE_OF_REPORT AS (
 	SELECT
 		CAST(MAX(DATE_OF_REPORT) as datetime) AS [LAST_DATE_OF_REPORT]
 	FROM [VWSDEST].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023]
 	WHERE DATE_OF_REPORT >=  '2020-03-16 00:00:00.000'
 		AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023])
 ),
 
 BASE_CTE AS (
 SELECT 
 	DATE_OF_REPORT,
 	DATE_OF_REPORT_UNIX AS [NEW_DATE_OF_REPORT_UNIX],
 	LAG([DATE_OF_REPORT_UNIX], 1, NULL) OVER (ORDER BY [DATE_LAST_INSERTED], [DATE_OF_REPORT_UNIX]) AS [OLD_DATE_OF_REPORT_UNIX],
 	LAG([NON_IC_BEDS_OCCUPIED_COVID], 1, NULL) OVER (ORDER BY [DATE_LAST_INSERTED], [DATE_OF_REPORT_UNIX]) AS [OLD_VALUE],
 	[NON_IC_BEDS_OCCUPIED_COVID] -
 		LAG([NON_IC_BEDS_OCCUPIED_COVID], 1, NULL) OVER (ORDER BY [DATE_LAST_INSERTED], [DATE_OF_REPORT_UNIX]) AS [DIFFERENCE]
 --  dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
 FROM [VWSDEST].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023]
 WHERE DATE_OF_REPORT >=  '2020-03-02 00:00:00.000'
 AND DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) 
                             FROM [VWSDEST].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023])
 
 )
 
 SELECT DATE_OF_REPORT
 	  ,NEW_DATE_OF_REPORT_UNIX AS NEW_DATE_UNIX
 	  ,OLD_DATE_OF_REPORT_UNIX AS OLD_DATE_UNIX
 	  ,CASE WHEN OLD_VALUE IS NULL THEN 0 ELSE OLD_VALUE END AS OLD_VALUE
 	  ,CASE WHEN [DIFFERENCE] IS NULL THEN 0 ELSE [DIFFERENCE] END AS [DIFFERENCE]
 FROM BASE_CTE T1
 WHERE DATE_OF_REPORT = (SELECT LAST_DATE_OF_REPORT FROM LAST_DATE_OF_REPORT)