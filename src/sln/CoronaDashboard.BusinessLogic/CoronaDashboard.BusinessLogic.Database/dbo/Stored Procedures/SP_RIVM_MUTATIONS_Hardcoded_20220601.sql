-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
CREATE   PROCEDURE [dbo].[SP_RIVM_MUTATIONS_Hardcoded_20220601]
AS
BEGIN

WITH BASE_CTE AS (
SELECT
       [DATE_OF_REPORT],
       [DATE_OF_STATISTICS_WEEK_START],
       [VARIANT_CODE],
       [VARIANT_NAME],
       [ECDC_CATEGORY],
       IIF([ECDC_CATEGORY] = 'VOC' 
            OR [VARIANT_CODE] = 'B.1.1.529'
            OR [VARIANT_NAME] IN ('Alpha', 'Beta','Gamma'), 'true','false') AS [IS_VARIANT_OF_CONCERN],
       IIF([VARIANT_NAME] IN ('Alpha','Beta','Gamma'), 'true', 'false') AS [HAS_HISTORICAL_SIGNIFICANCE],
       [SAMPLE_SIZE],
       [VARIANT_CASES],
       CAST([VARIANT_CASES] AS FLOAT) / [SAMPLE_SIZE] AS [VARIANT_PERCENTAGE],
       [DATE_LAST_INSERTED]
  FROM [VWSINTER].[RIVM_MUTATIONS]
  WHERE
       DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[RIVM_MUTATIONS]) AND
       VARIANT_NAME <> '' AND (
       ECDC_CATEGORY IN ('VOC', 'VOI')
       OR VARIANT_NAME IN (
                'Alpha'
                ,'Omicron'     -- toevoeging
                ,'Beta'
                ,'Gamma'
       --        ,'Delta'
       --        ,'Epsilon'
       --        ,'Eta'
       --        ,'Theta'
       --        ,'Kappa'
       --        --,'Lambda'
       )
       )
)
,
--Use a grid with all valid date and variant combinations
--to cover the situation that a variant is not present in all weeks
GRID_CTE AS (

    SELECT DISTINCT
         T0.[DATE_OF_STATISTICS_WEEK_START]
        ,T1.VARIANT_CODE
        FROM BASE_CTE AS T0
            CROSS JOIN
                (SELECT DISTINCT [VARIANT_CODE] FROM BASE_CTE) AS T1
),
FULL_CTE AS --Grid is filled with all present data
(
SELECT
    T0.[DATE_OF_STATISTICS_WEEK_START],
    T0.VARIANT_CODE,
    T1.[DATE_OF_REPORT],
    T1.[VARIANT_NAME],
    T1.[ECDC_CATEGORY],
    T1.[IS_VARIANT_OF_CONCERN],
    T1.[HAS_HISTORICAL_SIGNIFICANCE],
    T1.[SAMPLE_SIZE],
    T1.[VARIANT_CASES],
    T1.[VARIANT_PERCENTAGE],
    T1.[DATE_LAST_INSERTED]
  FROM GRID_CTE AS T0
    LEFT JOIN BASE_CTE AS T1 ON T0.[DATE_OF_STATISTICS_WEEK_START] = T1.[DATE_OF_STATISTICS_WEEK_START] AND T0.VARIANT_CODE = T1.VARIANT_CODE
)
,
TOTALS_CTE AS (
SELECT
       [DATE_OF_REPORT],
       [DATE_OF_STATISTICS_WEEK_START],
       MAX([SAMPLE_SIZE])                       AS [SAMPLE_SIZE],
       SUM([VARIANT_CASES])                     AS [VARIANT_CASES]

    FROM FULL_CTE
    WHERE ECDC_CATEGORY IN ('VOC', 'VOI') OR [VARIANT_CODE] = 'B.1.1.529'
           OR VARIANT_NAME IN (
                'Alpha'
                ,'Omicron'     -- toevoeging
                ,'Beta'
                ,'Gamma'
       --        ,'Delta'
       --        ,'Epsilon'
       --        ,'Eta'
       --        ,'Theta'
       --        ,'Kappa'
       --        --,'Lambda'
       )
    GROUP BY [DATE_OF_REPORT], [DATE_OF_STATISTICS_WEEK_START]
)
,
TOTALS_CTE2 AS (
SELECT
        [DATE_OF_REPORT],
        [DATE_OF_STATISTICS_WEEK_START],
        MAX([SAMPLE_SIZE])              AS [SAMPLE_SIZE],
        SUM([VARIANT_CASES])            AS [VARIANT_CASES]


     FROM FULL_CTE
     WHERE ECDC_CATEGORY IN ('VOC') or HAS_HISTORICAL_SIGNIFICANCE = 'true' OR [VARIANT_CODE] = 'B.1.1.529'
     GROUP BY [DATE_OF_REPORT], [DATE_OF_STATISTICS_WEEK_START]
)

INSERT INTO VWSDEST.RIVM_MUTATIONS
      (
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS_WEEK_START],
         [VARIANT_CODE],
         [VARIANT_NAME],
         [IS_VARIANT_OF_CONCERN],
         [HAS_HISTORICAL_SIGNIFICANCE],
         [SAMPLE_SIZE],
         [VARIANT_CASES],
         [VARIANT_PERCENTAGE]
      )

SELECT
       [DATE_OF_REPORT],
       [DATE_OF_STATISTICS_WEEK_START],
       [VARIANT_CODE],
       [VARIANT_NAME],
       [IS_VARIANT_OF_CONCERN],
       [HAS_HISTORICAL_SIGNIFICANCE],
       [SAMPLE_SIZE],
       [VARIANT_CASES],
       ROUND(CAST([VARIANT_CASES]*100 AS FLOAT) / [SAMPLE_SIZE],1) AS [VARIANT_PERCENTAGE]
  FROM [FULL_CTE]
UNION ALL
--other variants tabel
SELECT
       [DATE_OF_REPORT],
       [DATE_OF_STATISTICS_WEEK_START],
       ''                                       AS [VARIANT_CODE],
       'Other_Table'                            AS [VARIANT_NAME],
       'false'                                  AS [IS_VARIANT_OF_CONCERN],
       'false'                                  AS [HAS_HISTORICAL_SIGNIFICANCE],
       [SAMPLE_SIZE],
       [SAMPLE_SIZE] - [VARIANT_CASES]          AS [VARIANT_CASES],
       ROUND((CAST(([SAMPLE_SIZE] - [VARIANT_CASES]) AS FLOAT)*100) / [SAMPLE_SIZE],1) AS [VARIANT_PERCENTAGE]

 FROM TOTALS_CTE
UNION ALL
 --other variants grafiek
SELECT
       [DATE_OF_REPORT],
       [DATE_OF_STATISTICS_WEEK_START],
       ''                                       AS [VARIANT_CODE],
       'Other_Graph'                          AS [VARIANT_NAME],
       'false'                                  AS [IS_VARIANT_OF_CONCERN],
       'true'                                  AS [HAS_HISTORICAL_SIGNIFICANCE],
       [SAMPLE_SIZE],
       [SAMPLE_SIZE] - [VARIANT_CASES]          AS [VARIANT_CASES],
       ROUND((CAST(([SAMPLE_SIZE] - [VARIANT_CASES]) AS FLOAT)*100) / [SAMPLE_SIZE],1) AS [VARIANT_PERCENTAGE]

 FROM TOTALS_CTE2
END