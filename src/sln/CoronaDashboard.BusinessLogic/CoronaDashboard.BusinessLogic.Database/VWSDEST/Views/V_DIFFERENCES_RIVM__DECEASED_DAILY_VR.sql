﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 CREATE   VIEW [VWSDEST].[V_DIFFERENCES_RIVM__DECEASED_DAILY_VR] AS
 
 
 
 WITH LAST_DATE_OF_REPORT AS (
 	SELECT
 		VRCODE,
 		CAST(MAX(DATE_OF_REPORT) as datetime) AS [LAST_DATE_OF_REPORT]
 	FROM VWSDEST.RIVM_DECEASED_DAILY_PER_REGION WITH(NOLOCK)
 	WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.RIVM_DECEASED_DAILY_PER_REGION WITH(NOLOCK))
 	AND DATE_OF_REPORT < '2023-01-01' -- added as RIVM reports 9999 after this date
 	GROUP BY VRCODE
 ),
 BASE_CTE AS (
 SELECT 
 	DATE_OF_REPORT,
 	DATE_OF_REPORT_UNIX AS [NEW_DATE_OF_REPORT_UNIX],
 	LAG([DATE_OF_REPORT_UNIX], 1, NULL) OVER (PARTITION BY VRCODE ORDER BY DATE_LAST_INSERTED,[DATE_OF_REPORT_UNIX]) AS [OLD_DATE_OF_REPORT_UNIX],
 	VRCODE,
 	LAG(DBO.NO_NEGATIVE_NUMBER_I([DECEASED_ACTUAL]), 1, NULL) OVER (PARTITION BY VRCODE ORDER BY DATE_LAST_INSERTED,[DATE_OF_REPORT_UNIX]) AS [OLD_VALUE],
 	DBO.NO_NEGATIVE_NUMBER_I([DECEASED_ACTUAL]) -
 		LAG(DBO.NO_NEGATIVE_NUMBER_I([DECEASED_ACTUAL]), 1, NULL) OVER (PARTITION BY VRCODE ORDER BY DATE_LAST_INSERTED,[DATE_OF_REPORT_UNIX]) AS [DIFFERENCE]
 FROM VWSDEST.RIVM_DECEASED_DAILY_PER_REGION WITH(NOLOCK)
 WHERE DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) 
                             FROM VWSDEST.RIVM_DECEASED_DAILY_PER_REGION WITH(NOLOCK))
 )
 SELECT DATE_OF_REPORT
 	  ,NEW_DATE_OF_REPORT_UNIX AS NEW_DATE_UNIX
 	  ,OLD_DATE_OF_REPORT_UNIX AS OLD_DATE_UNIX
       ,T1.VRCODE
 	  ,CASE WHEN OLD_VALUE IS NULL THEN 0 ELSE OLD_VALUE END AS OLD_VALUE
 	  ,CASE WHEN [DIFFERENCE] IS NULL THEN 0 ELSE [DIFFERENCE] END AS [DIFFERENCE]
 FROM BASE_CTE T1
 LEFT JOIN LAST_DATE_OF_REPORT T2
 	ON T1.[VRCODE] = T2.[VRCODE]
 WHERE DATE_OF_REPORT = LAST_DATE_OF_REPORT