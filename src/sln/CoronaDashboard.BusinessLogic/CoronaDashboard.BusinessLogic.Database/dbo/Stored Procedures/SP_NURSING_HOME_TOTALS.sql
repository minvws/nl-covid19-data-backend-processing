﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move data Nursery data from intermediate to destination table.
CREATE   PROCEDURE DBO.SP_NURSING_HOME_TOTALS
AS
BEGIN
    WITH BASE_CTE AS (
        SELECT
            DATE_OF_STATISTIC_REPORTED AS DATE_OF_REPORT,
            dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_STATISTIC_REPORTED) AS DATE_OF_REPORT_UNIX,
            TOTAL_CASES_REPORTED AS INFECTED_NURSERY_DAILY,
            TOTAL_DECEASED_REPORTED AS DECEASED_NURSERY_DAILY,
            TOTAL_NEW_INFECTED_LOCATIONS_REPORTED AS TOTAL_NEW_REPORTED_LOCATIONS,
            TOTAL_INFECTED_LOCATIONS_REPORTED AS TOTAL_REPORTED_LOCATIONS
        FROM
            VWSINTER.RIVM_NURSING_HOMES_COMBINED
        WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSINTER.RIVM_NURSING_HOMES_COMBINED)
            AND DATE_OF_STATISTIC_REPORTED > '1900-01-01 00:00:00.000'
    )

,TOTALS_CTE AS (
    SELECT 
         DATE_OF_REPORT
        ,DATE_OF_REPORT_UNIX
		,SUM(INFECTED_NURSERY_DAILY) AS INFECTED_NURSERY_DAILY_SUM
        ,SUM(DECEASED_NURSERY_DAILY) AS DECEASED_NURSERY_DAILY_SUM
		,SUM(TOTAL_NEW_REPORTED_LOCATIONS) AS TOTAL_NEW_REPORTED_LOCATIONS_SUM
        ,SUM(TOTAL_REPORTED_LOCATIONS) AS TOTAL_REPORTED_LOCATIONS_SUM
		,LAG ([DATE_OF_REPORT] ,6) OVER (ORDER BY DATE_OF_REPORT ASC)  AS [DATE_RANGE_START]
		,LAG (DATE_OF_REPORT ,1)   OVER (ORDER BY DATE_OF_REPORT ASC)  AS [DATE_OF_REPORTS_LAG]
		,LAG (DATE_OF_REPORT ,7)   OVER (ORDER BY DATE_OF_REPORT ASC)  AS [DATE_RANGE_START_LAG]
    FROM BASE_CTE
	    GROUP BY DATE_OF_REPORT_UNIX, DATE_OF_REPORT
)


INSERT INTO VWSDEST.NURSING_HOMES_TOTALS
          (DATE_OF_REPORT
          ,DATE_OF_REPORT_UNIX
		  ,INFECTED_NURSERY_DAILY
		  ,DECEASED_NURSERY_DAILY
		  ,TOTAL_NEW_REPORTED_LOCATIONS
		  ,TOTAL_REPORTED_LOCATIONS
          ,[DATE_RANGE_START]
		  ,[DATE_OF_REPORTS_LAG]
		  ,[DATE_RANGE_START_LAG]
	      ,[7D_AVERAGE_TOTAL_INFECTED]
          ,[7D_AVERAGE_TOTAL_INFECTED_LAG]
		  ,[7D_AVERAGE_TOTAL_DECEASED]
		  ,[7D_AVERAGE_TOTAL_DECEASED_LAG])
    SELECT 
         DATE_OF_REPORT
        ,DATE_OF_REPORT_UNIX
		,INFECTED_NURSERY_DAILY_SUM
		,DECEASED_NURSERY_DAILY_SUM
		,TOTAL_NEW_REPORTED_LOCATIONS_SUM
        ,TOTAL_REPORTED_LOCATIONS_SUM
		,[DATE_RANGE_START]
		,[DATE_OF_REPORTS_LAG]
		,[DATE_RANGE_START_LAG]
        --Only show 7 day averages whebn 7 days are available.
		,IIF(DATE_RANGE_START IS NULL, NULL,
            ROUND(AVG(CAST([INFECTED_NURSERY_DAILY_SUM]     AS FLOAT)) OVER (ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),1)) as [7D_AVERAGE_TOTAL_INFECTED]
        ,IIF(DATE_RANGE_START_LAG IS NULL, NULL,
            ROUND(AVG(CAST([INFECTED_NURSERY_DAILY_SUM]     AS FLOAT)) OVER (ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING),1)) as [7D_AVERAGE_TOTAL_INFECTED_LAG]
        ,IIF(DATE_RANGE_START IS NULL, NULL,
            ROUND(AVG(CAST([DECEASED_NURSERY_DAILY_SUM]     AS FLOAT)) OVER (ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),1)) as [7D_AVERAGE_TOTAL_DECEASED]
        ,IIF(DATE_RANGE_START_LAG IS NULL, NULL,
            ROUND(AVG(CAST([DECEASED_NURSERY_DAILY_SUM]     AS FLOAT)) OVER (ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING),1)) as [7D_AVERAGE_TOTAL_DECEASED_LAG]
    FROM TOTALS_CTE  
END;