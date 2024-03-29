﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   VIEW [VWSDEST].[V_DIFFERENCE_RIVM_SEWER_MEASUREMENTS_NL_2023] AS
 
 WITH CTE1 AS
 (
 	SELECT
 		dbo.CONVERT_DATETIME_TO_UNIX([DATE_MEASUREMENT]) AS [NEW_DATE_UNIX],
 		LAG(dbo.CONVERT_DATETIME_TO_UNIX([DATE_MEASUREMENT]), 1, NULL) OVER (ORDER BY [DATE_MEASUREMENT]) AS [OLD_DATE_UNIX],
 		CAST(round(([RNA_FLOW_PER_100000] / 1.0E+11),0) as INT) AS [NEW_VALUE],
 		LAG(CAST(round(([RNA_FLOW_PER_100000] / 1.0E+11),0) as INT), 1, NULL) OVER (ORDER BY [DATE_MEASUREMENT]) AS [OLD_VALUE]
 	FROM [VWSDEST].[RIVM_SEWER_MEASUREMENTS_NL_2023]
 	WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[RIVM_SEWER_MEASUREMENTS_NL_2023])
 )
 SELECT
 	CTE1.[NEW_DATE_UNIX], 
 	CTE1.[OLD_DATE_UNIX], 
 	CTE1.[OLD_VALUE], 
 	CTE1.[NEW_VALUE] - CTE1.[OLD_VALUE] AS [DIFFERENCE]
 FROM CTE1
 WHERE CTE1.[NEW_DATE_UNIX] = (SELECT MAX([NEW_DATE_UNIX]) FROM CTE1); -- only take last value