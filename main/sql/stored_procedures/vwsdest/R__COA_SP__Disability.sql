-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER  PROCEDURE [dbo].[SP_DISABILITY_Dest]
AS
BEGIN
    WITH BASE_CTE AS (
        SELECT
            DATE_OF_STATISTIC_REPORTED AS DATE_OF_REPORT,
            dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_STATISTIC_REPORTED) AS DATE_OF_REPORT_UNIX,
            TOTAL_CASES_REPORTED AS INFECTED_DISABILITY_DAILY,
            TOTAL_DECEASED_REPORTED AS DECEASED_DISABILITY_DAILY,
            TOTAL_NEW_INFECTED_LOCATIONS_REPORTED AS TOTAL_NEW_INFECTED_LOCATIONS,
            TOTAL_INFECTED_LOCATIONS_REPORTED AS TOTAL_INFECTED_LOCATIONS,
            (select COUNT_LOC_DISABILITY from VWSSTATIC.NUMBER_OF_LOCATIONS_NURSING_DISABILITY where VRCODE='NL00' AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.NUMBER_OF_LOCATIONS_NURSING_DISABILITY)) as TOTAL_LOCATIONS
        FROM
            VWSINTER.DISABILITY
        WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSINTER.DISABILITY)
            AND DATE_OF_STATISTIC_REPORTED > '1900-01-01 00:00:00.000'
   )

, TOTALS_CTE AS (
    SELECT 
         DATE_OF_REPORT
        ,DATE_OF_REPORT_UNIX
        ,SUM(INFECTED_DISABILITY_DAILY) AS INFECTED_DISABILITY_DAILY
        ,SUM(DECEASED_DISABILITY_DAILY) AS DECEASED_DISABILITY_DAILY
        ,SUM(TOTAL_NEW_INFECTED_LOCATIONS) AS TOTAL_NEW_INFECTED_LOCATIONS
        ,SUM(TOTAL_INFECTED_LOCATIONS) AS TOTAL_INFECTED_LOCATIONS
		,max(TOTAL_LOCATIONS)		   AS TOTAL_LOCATIONS
		,ROUND(100*SUM(TOTAL_INFECTED_LOCATIONS)/max(TOTAL_LOCATIONS),2) AS PERCENTAGE_INFECTED_LOCATIONS 
		,LAG ([DATE_OF_REPORT] ,6) OVER (ORDER BY DATE_OF_REPORT ASC)  AS [DATE_RANGE_START]
		,LAG (DATE_OF_REPORT ,1)   OVER (ORDER BY DATE_OF_REPORT ASC)  AS [DATE_OF_REPORTS_LAG]
		,LAG (DATE_OF_REPORT ,7)   OVER (ORDER BY DATE_OF_REPORT ASC)  AS [DATE_RANGE_START_LAG]
    FROM BASE_CTE
	    GROUP BY DATE_OF_REPORT_UNIX, DATE_OF_REPORT
		)

  INSERT INTO VWSDEST.DISABILITY
        (
             DATE_OF_REPORT
            ,DATE_OF_REPORT_UNIX
            ,INFECTED_DISABILITY_DAILY
            ,DECEASED_DISABILITY_DAILY
            ,TOTAL_NEW_INFECTED_LOCATIONS
            ,TOTAL_INFECTED_LOCATIONS
            ,TOTAL_LOCATIONS
            ,PERCENTAGE_INFECTED_LOCATIONS
		    ,[DATE_RANGE_START]
		    ,[DATE_OF_REPORTS_LAG]
		    ,[DATE_RANGE_START_LAG]
	        ,[7D_AVERAGE_TOTAL_INFECTED]
            ,[7D_AVERAGE_TOTAL_INFECTED_LAG]
		    ,[7D_AVERAGE_TOTAL_DECEASED]
		    ,[7D_AVERAGE_TOTAL_DECEASED_LAG]
        )
    SELECT
		    DATE_OF_REPORT
           ,DATE_OF_REPORT_UNIX
           ,INFECTED_DISABILITY_DAILY
           ,DECEASED_DISABILITY_DAILY
           ,TOTAL_NEW_INFECTED_LOCATIONS
           ,TOTAL_INFECTED_LOCATIONS
           ,TOTAL_LOCATIONS 
           ,PERCENTAGE_INFECTED_LOCATIONS
		   ,[DATE_RANGE_START]
		   ,[DATE_OF_REPORTS_LAG]
		   ,[DATE_RANGE_START_LAG]
		   ,CASE WHEN
				[DATE_RANGE_START] IS NULL THEN NULL
				ELSE ROUND(AVG(CAST([INFECTED_DISABILITY_DAILY]     AS FLOAT)) OVER (ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),1) 
			END AS [7D_AVERAGE_TOTAL_INFECTED]
           ,CASE WHEN
				[DATE_RANGE_START_LAG] IS NULL THEN NULL
				ELSE ROUND(AVG(CAST([INFECTED_DISABILITY_DAILY]      AS FLOAT)) OVER (ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING),1) 
			END AS [7D_AVERAGE_TOTAL_INFECTED_LAG]
		   ,CASE WHEN
				[DATE_RANGE_START] IS NULL THEN NULL
				ELSE ROUND(AVG(CAST([DECEASED_DISABILITY_DAILY]     AS FLOAT)) OVER (ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),1) 
			END AS [7D_AVERAGE_TOTAL_DECEASED]
           ,CASE WHEN 
				[DATE_RANGE_START_LAG] IS NULL THEN NULL
				ELSE ROUND(AVG(CAST([DECEASED_DISABILITY_DAILY]     AS FLOAT)) OVER (ORDER BY [DATE_OF_REPORT] ASC ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING),1) 
			END AS [7D_AVERAGE_TOTAL_DECEASED_LAG]
    FROM TOTALS_CTE
END;
GO