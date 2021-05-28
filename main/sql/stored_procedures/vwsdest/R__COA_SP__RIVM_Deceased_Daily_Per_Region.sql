-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE [dbo].[SP_RIVM_DECEASED_DAILY]
AS
BEGIN

WITH BASE_CTE AS (
SELECT
    DATE_OF_PUBLICATION
,   SUM(DECEASED) AS DECEASED_ACTUAL
,   SECURITY_REGION_CODE
FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY)
GROUP BY DATE_OF_PUBLICATION, SECURITY_REGION_CODE
)
,
SECOND_CTE AS 
(
    SELECT
       DATE_OF_PUBLICATION
    ,  dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_PUBLICATION) DATE_OF_PUBLICATION_UNIX
    ,   DECEASED_ACTUAL
    ,   SUM(DECEASED_ACTUAL) OVER(PARTITION BY SECURITY_REGION_CODE ORDER BY DATE_OF_PUBLICATION ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS COVID_TOTAL
    ,   SECURITY_REGION_CODE

    -- 7d average
	,LAG ([DATE_OF_PUBLICATION] ,6) OVER (PARTITION BY SECURITY_REGION_CODE ORDER BY [DATE_OF_PUBLICATION] ASC) WEEK_START
	,LAG ([DATE_OF_PUBLICATION] ,7) OVER (PARTITION BY SECURITY_REGION_CODE ORDER BY [DATE_OF_PUBLICATION] ASC) WEEK_START_LAG
	,AVG(CAST([DECEASED_ACTUAL] AS FLOAT)) OVER (PARTITION BY SECURITY_REGION_CODE ORDER BY DATE_OF_PUBLICATION ASC ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as DECEASED_7D_AVG
	,AVG(CAST([DECEASED_ACTUAL] AS FLOAT)) OVER (PARTITION BY SECURITY_REGION_CODE ORDER BY DATE_OF_PUBLICATION ASC ROWS BETWEEN 7 PRECEDING AND 1 PRECEDING) as DECEASED_7D_AVG_LAG
	
    FROM BASE_CTE
)   

INSERT INTO VWSDEST.RIVM_DECEASED_DAILY_PER_REGION
(
    DATE_OF_REPORT
,   DATE_OF_REPORT_UNIX
,   DECEASED_ACTUAL
,   DECEASED_CUMULATIVE
,   VRCODE
,	WEEK_START
,   DECEASED_7D_AVG
,	WEEK_START_LAG
,   DECEASED_7D_AVG_LAG

)

SELECT 
       [DATE_OF_PUBLICATION]
      ,[DATE_OF_PUBLICATION_UNIX]
      ,DECEASED_ACTUAL
      ,COVID_TOTAL
      ,SECURITY_REGION_CODE
      ,WEEK_START
      ,IIF(WEEK_START IS NULL, NULL, ROUND(DECEASED_7D_AVG,1)) AS DECEASED_7D_AVG
      ,WEEK_START_LAG
      ,IIF(WEEK_START_LAG IS NULL, NULL, ROUND(DECEASED_7D_AVG_LAG,1)) AS DECEASED_7D_AVG_LAG
FROM SECOND_CTE

END
GO