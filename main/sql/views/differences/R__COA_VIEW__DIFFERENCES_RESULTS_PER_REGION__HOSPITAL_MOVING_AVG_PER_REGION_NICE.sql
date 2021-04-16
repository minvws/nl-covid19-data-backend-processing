-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor  more information.
/****** Object:  View [VWSDEST].[V_DIFFERENCE_RESULTS_PER_REGION__HOSPITAL_MOVING_AVG_PER_REGION_NICE]    Script Date: 12-11-2020 15:14:55 ******/

CREATE OR ALTER VIEW [VWSDEST].[V_DIFFERENCE_RESULTS_PER_REGION__HOSPITAL_MOVING_AVG_PER_REGION_NICE] AS

WITH LAST_DATE_OF_REPORT AS (
	SELECT
		VR_CODE,
		CAST(MAX(DATE_OF_STATISTICS) as datetime) AS [LAST_DATE_OF_REPORT]
	FROM VWSDEST.NICE_HOSPITAL_VR
	WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.NICE_HOSPITAL_VR)
	GROUP BY VR_CODE
),

BASE_CTE AS (
SELECT 
	DATE_OF_STATISTICS AS DATE_OF_REPORT,
	dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_STATISTICS]) AS [NEW_DATE_OF_REPORT_UNIX],
	VR_CODE,
	LAG(dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_STATISTICS]), 1, NULL) OVER (PARTITION BY [VR_CODE] ORDER BY [DATE_LAST_INSERTED], DATE_OF_STATISTICS) AS [OLD_DATE_OF_REPORT_UNIX],
    LAG(DBO.NO_NEGATIVE_NUMBER_F(HOSPITALIZED_3D_AVG), 1, NULL) OVER (PARTITION BY [VR_CODE] ORDER BY [DATE_LAST_INSERTED], [DATE_OF_STATISTICS]) AS [OLD_VALUE],
	DBO.NO_NEGATIVE_NUMBER_F(HOSPITALIZED_3D_AVG) -
		LAG(DBO.NO_NEGATIVE_NUMBER_F(HOSPITALIZED_3D_AVG), 1, NULL) OVER (PARTITION BY [VR_CODE] ORDER BY [DATE_LAST_INSERTED], [DATE_OF_STATISTICS]) AS [DIFFERENCE]
--  dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.NICE_HOSPITAL_VR
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM VWSDEST.NICE_HOSPITAL_VR)
)

SELECT DATE_OF_REPORT
	  ,NEW_DATE_OF_REPORT_UNIX AS NEW_DATE_UNIX
	  ,T1.VR_CODE AS VRCODE
	  ,OLD_DATE_OF_REPORT_UNIX AS OLD_DATE_UNIX
	  ,OLD_VALUE
	  ,[DIFFERENCE]
FROM BASE_CTE T1
LEFT JOIN LAST_DATE_OF_REPORT T2
	ON T1.[VR_CODE] = T2.[VR_CODE]
WHERE DATE_OF_REPORT = LAST_DATE_OF_REPORT
;

GO


