-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE OR ALTER PROCEDURE DBO.SP_G_Number_VR
AS
BEGIN

    -- Calculate positive 7 daily sum
    WITH SUMMED AS (
        SELECT [DATE_OF_REPORT]
              ,[DATE_RANGE_START]
              ,CASE WHEN count(TOTAL_REPORTED_INCREASE_PER_REGION) OVER (PARTITION BY VRCODE ORDER BY DATE_OF_REPORT ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) = 7
                THEN SUM(CAST(TOTAL_REPORTED_INCREASE_PER_REGION AS FLOAT)) OVER (PARTITION BY VRCODE ORDER BY DATE_OF_REPORT ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
                ELSE NULL
              END AS POSITIVE_DAILY_7D_SUM
              ,[VRCODE]
        FROM [VWSDEST].[RESULTS_PER_REGION]
        WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from [VWSDEST].[RESULTS_PER_REGION])
    )

    -- Calculate percentual change between with previous 7D sum
    INSERT INTO VWSDEST.G_NUMBER_VR
        (
         [DATE_OF_REPORT]
        ,[DATE_RANGE_START]
        ,[VRCODE]
        ,[POSITIVE_DAILY_7D_SUM]
        ,[G_NUMBER]
        )
    SELECT [DATE_OF_REPORT]
          ,[DATE_RANGE_START]
          ,[VRCODE]
          ,[POSITIVE_DAILY_7D_SUM]
          ,dbo.CALC_PERC_CHANGE(POSITIVE_DAILY_7D_SUM, LAG(POSITIVE_DAILY_7D_SUM, 7, NULL) OVER (PARTITION BY VRCODE ORDER BY DATE_OF_REPORT)) * 100 AS G_NUMBER
    FROM SUMMED
END;



