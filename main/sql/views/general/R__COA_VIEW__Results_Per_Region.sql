-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

/*DEPRECATED*/

-- CREATE OR ALTER VIEW VWSDEST.V_RESULTS_PER_REGION AS
-- SELECT 
--     [DATE_OF_REPORT_UNIX],
--     VRCODE,
--     DBO.NO_NEGATIVE_NUMBER_F(TOTAL_REPORTED_INCREASE_PER_REGION) AS TOTAL_REPORTED_INCREASE_PER_REGION,
--     DBO.NO_NEGATIVE_NUMBER_F(INFECTED_TOTAL_COUNTS_PER_REGION) AS INFECTED_TOTAL_COUNTS_PER_REGION,
-- 	DBO.NO_NEGATIVE_NUMBER_F(HOSPITAL_TOTAL_COUNTS_PER_REGION) AS HOSPITAL_TOTAL_COUNTS_PER_REGION,
-- 	DBO.NO_NEGATIVE_NUMBER_F(INFECTED_INCREASE_PER_REGION) AS INFECTED_INCREASE_PER_REGION,
-- 	DBO.NO_NEGATIVE_NUMBER_F(HOSPITAL_INCREASE_PER_REGION) AS HOSPITAL_INCREASE_PER_REGION,
-- 	DBO.NO_NEGATIVE_NUMBER_F(HOSPITAL_MOVING_AVG_PER_REGION) AS HOSPITAL_MOVING_AVG_PER_REGION,
--     dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
-- FROM VWSDEST.RESULTS_PER_REGION
-- WHERE DATE_OF_REPORT >=  '2020-03-16 00:00:00.000'
-- AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
--                             FROM VWSDEST.RESULTS_PER_REGION);

CREATE OR ALTER VIEW VWSDEST.V_RESULTS_PER_REGION AS
SELECT 
    T1.[DATE_OF_REPORT_UNIX] AS DATE_UNIX,
    VRCODE,
    DBO.NO_NEGATIVE_NUMBER_F(TOTAL_REPORTED_INCREASE_PER_REGION) AS INFECTED,
    DBO.NO_NEGATIVE_NUMBER_F(INFECTED_TOTAL_COUNTS_PER_REGION) AS INFECTED_TOTAL_COUNTS_PER_REGION,
	DBO.NO_NEGATIVE_NUMBER_F(INFECTED_INCREASE_PER_REGION) AS INFECTED_PER_100K,
	DBO.NO_NEGATIVE_NUMBER_F(T2.HOSPITALIZED_3D_AVG) AS ADMISSIONS_MOVING_AVERAGE,
    DBO.NO_NEGATIVE_NUMBER_I(T2.REPORTED) AS ADMISSIONS_ON_DATE_OF_REPORTING,
    DBO.NO_NEGATIVE_NUMBER_I(T2.HOSPITALIZED) AS ADMISSIONS_ON_DATE_OF_ADMISSION,
    dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.RESULTS_PER_REGION T1
LEFT JOIN (
    SELECT      
       [dbo].[CONVERT_DATETIME_TO_UNIX]([DATE_OF_STATISTICS]) AS [DATE_OF_REPORT_UNIX]
      ,[VR_CODE]
      ,[HOSPITALIZED]
      ,[HOSPITALIZED_3D_AVG]
      ,[HOSPITALIZED_CUMULATIVE]
      ,REPORTED
  FROM [VWSDEST].[NICE_HOSPITAL_VR]
  WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[NICE_HOSPITAL_VR])
) T2 on T1.DATE_OF_REPORT_UNIX = T2.DATE_OF_REPORT_UNIX AND T1.VRCODE = T2.VR_CODE
WHERE DATE_OF_REPORT >=  '2020-03-16 00:00:00.000'
AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM VWSDEST.RESULTS_PER_REGION);