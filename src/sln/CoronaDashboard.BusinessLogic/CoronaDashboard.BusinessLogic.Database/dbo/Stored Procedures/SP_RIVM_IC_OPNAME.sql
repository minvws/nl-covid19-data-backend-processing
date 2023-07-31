﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE [dbo].[SP_RIVM_IC_OPNAME]
AS
BEGIN
WITH BASE_CTE AS (
  SELECT
    [VERSION],
	DATE_OF_REPORT,
	[dbo].[CONVERT_DATETIME_TO_UNIX](DATE_OF_REPORT) AS DATE_OF_REPORT_UNIX,
    DATE_OF_STATISTICS,
	[dbo].[CONVERT_DATETIME_TO_UNIX](DATE_OF_STATISTICS) AS DATE_OF_STATISTICS_UNIX,
    IC_ADMISSION_NOTIFICATION,
    IC_ADMISSION,

    --Calculations for differences
    [dbo].[CONVERT_DATETIME_TO_UNIX](DATE_OF_STATISTICS) AS OLD_DATE_OF_STATISTICS_UNIX,
    LAG(IC_ADMISSION_NOTIFICATION, 1) OVER (ORDER BY DATE_OF_STATISTICS) AS OLD_IC_ADMISSION_NOTIFICATION,
    LAG(IC_ADMISSION, 1) OVER (ORDER BY DATE_OF_STATISTICS) AS OLD_IC_ADMISSION,
    
    -- 7d average
    AVG(CAST([IC_ADMISSION] AS FLOAT)) OVER (ORDER BY DATE_OF_STATISTICS ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as IC_ADMISSION_7D_AVG,
    AVG(CAST([IC_ADMISSION] AS FLOAT)) OVER (ORDER BY DATE_OF_STATISTICS ASC ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) as IC_ADMISSION_7D_AVG_LAG,
    LAG ([DATE_OF_STATISTICS] ,6) OVER (ORDER BY [DATE_OF_STATISTICS] ASC) as WEEK_START,
    LAG ([DATE_OF_STATISTICS] ,7) OVER (ORDER BY [DATE_OF_STATISTICS] ASC) as WEEK_START_LAG,
    AVG(CAST([IC_ADMISSION_NOTIFICATION] AS FLOAT)) OVER (ORDER BY DATE_OF_STATISTICS ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as IC_ADMISSION_NOTIFICATION_7D_AVG,
    AVG(CAST([IC_ADMISSION_NOTIFICATION] AS FLOAT)) OVER (ORDER BY DATE_OF_STATISTICS ASC ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) as IC_ADMISSION_NOTIFICATION_7D_AVG_LAG


	FROM 
        VWSINTER.RIVM_IC_OPNAME
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                                  FROM VWSINTER.RIVM_IC_OPNAME)
)

INSERT INTO VWSDEST.RIVM_IC_OPNAME(
    [VERSION],
	DATE_OF_REPORT,
	DATE_OF_REPORT_UNIX,
    DATE_OF_STATISTICS,
	DATE_OF_STATISTICS_UNIX,
    IC_ADMISSION_NOTIFICATION,
    IC_ADMISSION,
    OLD_DATE_OF_STATISTICS_UNIX,
    OLD_IC_ADMISSION_NOTIFICATION,
    OLD_IC_ADMISSION,
 	WEEK_START,
    IC_ADMISSION_7D_AVG,
    IC_ADMISSION_NOTIFICATION_7D_AVG,
    WEEK_START_LAG,
    IC_ADMISSION_7D_AVG_LAG,
    IC_ADMISSION_NOTIFICATION_7D_AVG_LAG
    )

SELECT 
    [VERSION],
	DATE_OF_REPORT,
	DATE_OF_REPORT_UNIX,
    DATE_OF_STATISTICS,
	DATE_OF_STATISTICS_UNIX,
    IC_ADMISSION_NOTIFICATION,
    IC_ADMISSION,
    OLD_DATE_OF_STATISTICS_UNIX,
    OLD_IC_ADMISSION_NOTIFICATION,
    OLD_IC_ADMISSION,

    --7d averages
    WEEK_START,
    IIF(WEEK_START IS NULL, NULL, ROUND(IC_ADMISSION_7D_AVG,1)) AS IC_ADMISSION_7D_AVG,
    IIF(WEEK_START IS NULL, NULL, ROUND(IC_ADMISSION_NOTIFICATION_7D_AVG,1)) AS IC_ADMISSION_NOTIFICATION_7D_AVG,
    WEEK_START_LAG,
    IIF(WEEK_START_LAG IS NULL, NULL, ROUND(IC_ADMISSION_7D_AVG_LAG,1)) AS IC_ADMISSION_7D_AVG_LAG,
    IIF(WEEK_START_LAG IS NULL, NULL, ROUND(IC_ADMISSION_NOTIFICATION_7D_AVG_LAG,1)) AS IC_ADMISSION_NOTIFICATION_7D_AVG_LAG

FROM BASE_CTE
END;