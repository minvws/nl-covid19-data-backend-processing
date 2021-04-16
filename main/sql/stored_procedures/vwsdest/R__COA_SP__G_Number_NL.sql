-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE OR ALTER PROCEDURE DBO.SP_G_Number_NL
AS
BEGIN

    -- Calculate positive 7 daily sum
    WITH SUMMED AS (
        SELECT [DATE_OF_REPORT]
              ,[DATE_OF_REPORT_UNIX]
              ,DATEADD(day, -6, DATE_OF_REPORT) AS DATE_OF_REPORT_START
              ,CASE WHEN count(INFECTED_DAILY_TOTAL) OVER (ORDER BY DATE_OF_REPORT ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) = 7
                THEN SUM(CAST(INFECTED_DAILY_TOTAL AS FLOAT)) OVER (ORDER BY DATE_OF_REPORT ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
                ELSE NULL
              END AS POSITIVE_DAILY_7D_SUM
        FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE]
        WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE])
    )

    -- Calculate percentual change between with previous 7D sum
    INSERT INTO VWSDEST.G_NUMBER_NL
        (
         [DATE_OF_REPORT]
        ,[DATE_OF_REPORT_UNIX]
        ,[DATE_OF_REPORT_START]
        ,[POSITIVE_DAILY_7D_SUM]
        ,[G_NUMBER]
        )
    SELECT [DATE_OF_REPORT]
          ,[DATE_OF_REPORT_UNIX]
          ,[DATE_OF_REPORT_START]
          ,[POSITIVE_DAILY_7D_SUM]
          ,dbo.CALC_PERC_CHANGE(POSITIVE_DAILY_7D_SUM, LAG(POSITIVE_DAILY_7D_SUM, 7, NULL) OVER (ORDER BY DATE_OF_REPORT)) * 100 AS G_NUMBER
    FROM SUMMED
END;



