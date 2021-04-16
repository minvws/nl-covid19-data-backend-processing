-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER VIEW [VWSDEST].[V_RIVM_DECEASED_PER_WEEK]
AS
WITH BASE_CTE AS (
    SELECT
    SUM(DECEASED_ACTUAL) AS DECEASED_ACTUAL
,   WEEK_START_UNIX AS WEEK_START_UNIX
,   MAX(DATE_LAST_INSERTED) AS DATE_LAST_INSERTED
FROM [VWSDEST].[RIVM_DECEASED_PER_WEEK]
WHERE WEEK_START >= '2020-03-16 00:00:00.000'
AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[RIVM_DECEASED_PER_WEEK])
GROUP BY WEEK_START_UNIX
)

SELECT
    DECEASED_ACTUAL AS COVID_DAILY
,   SUM(DECEASED_ACTUAL) OVER(ORDER BY WEEK_START_UNIX ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS COVID_TOTAL
,   WEEK_START_UNIX AS DATE_UNIX
,   [dbo].[CONVERT_DATETIME_TO_UNIX](DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM BASE_CTE