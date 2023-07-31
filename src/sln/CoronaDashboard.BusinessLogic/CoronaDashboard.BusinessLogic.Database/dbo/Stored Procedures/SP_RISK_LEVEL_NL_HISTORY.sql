-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE [dbo].[SP_RISK_LEVEL_NL_HISTORY]
AS
BEGIN

WITH HOSP_ADM_CTE AS (
    --Get the records for which a 7d average will be shown on the dashboard
    SELECT 
         [DATE_OF_STATISTICS]
        ,[WEEK_START]
        ,ROUND(HOSPITALIZED_7D_AVG_CUTOFF,1) AS HOSP_7D_AVG
        ,DATE_LAST_INSERTED
    FROM [VWSDEST].[NICE_HOSPITAL_NL]
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[NICE_HOSPITAL_NL] )
      AND [HOSPITALIZED_7D_AVG_CUTOFF] IS NOT NULL
)
,
HOSP_ADM_KPI_CTE AS (
    --Get the latest value on which the risk level is based.
    SELECT 
             [DATE_OF_STATISTICS]
            ,[WEEK_START]
            ,[HOSP_7D_AVG] 
            ,DATE_LAST_INSERTED
    FROM HOSP_ADM_CTE
    WHERE [DATE_OF_STATISTICS] = (SELECT MAX([DATE_OF_STATISTICS]) FROM HOSP_ADM_CTE)
)
,
IC_ADM_RANK_TABLE_CTE AS (
    SELECT
     [DATE_OF_STATISTICS]
    ,[WEEK_START]
    ,ROUND(IC_ADMISSION_7D_AVG,1) AS IC_7D_AVG
    ,DATE_LAST_INSERTED
    ,ROW_NUMBER() OVER (ORDER BY DATE_OF_STATISTICS DESC) AS RANK_DATE
    FROM VWSDEST.RIVM_IC_OPNAME
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.RIVM_IC_OPNAME)
)
,
--This cutoff logic below is also used for the risk level determination in [VWSDEST].[V_RIVM_INTENSIVE_CARE_ADMISSIONS]
IC_ADM_CTE AS (
    SELECT
         [DATE_OF_STATISTICS]
        ,[WEEK_START]
        ,IIF(RANK_DATE>3,IC_7D_AVG,NULL) AS IC_7D_AVG
        ,DATE_LAST_INSERTED
    FROM IC_ADM_RANK_TABLE_CTE
    WHERE RANK_DATE>3
),
IC_ADM_KPI_CTE AS (
    --Get the latest value on which the risk level is based.
    SELECT 
             [DATE_OF_STATISTICS]
            ,[WEEK_START]
            ,[IC_7D_AVG] 
            ,DATE_LAST_INSERTED
    FROM IC_ADM_CTE
    WHERE [DATE_OF_STATISTICS] = (SELECT MAX([DATE_OF_STATISTICS]) FROM IC_ADM_CTE)
)
,
RISK_HISTORY_CTE AS (
    --Get the last valid risk level record
    SELECT 
        [RISK_LEVEL]
        ,[VALID_FROM]
        ,[DATE_LAST_INSERTED]
    FROM [VWSDEST].[RISK_LEVEL_NL_HISTORY]
    WHERE VALID = 1 
        AND [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RISK_LEVEL_NL_HISTORY] WHERE VALID = 1 ) )
,
KPI_CTE AS (
    SELECT 
                T0.[WEEK_START]                                         AS HOSP_WEEK_START
                ,T0.[DATE_OF_STATISTICS]                                AS HOSP_WEEK_END  
                ,T0.[HOSP_7D_AVG]                                       AS HOSP_7D_AVG    
                ,T0.DATE_LAST_INSERTED                                  AS HOSP_INSERTION

                ,T1.[WEEK_START]                                        AS IC_WEEK_START
                ,T1.[DATE_OF_STATISTICS]                                AS IC_WEEK_END  
                ,T1.[IC_7D_AVG]                                         AS IC_7D_AVG  
                ,T1.DATE_LAST_INSERTED                                  AS IC_INSERTION

                ,T2.[RISK_LEVEL_1]                                         
                ,T2.[RISK_LEVEL_2]                                         
                ,T2.[RISK_LEVEL_3]                                         
                ,T2.[IC_LOWER]                                                 
                ,T2.[IC_UPPER]                                             
                ,T2.[HOSP_LOWER]                                           
                ,T2.[HOSP_UPPER]                                           
                ,T2.[GELDIG VANAF]                                      AS THRESHOLD_VALID_FROM

                ,T3.RISK_LEVEL                                          AS HISTORIC_RISK_LEVEL   
                ,T3.VALID_FROM                                          AS HISTORIC_RISK_VALID_FROM
    FROM
        -- CTE's below all return 1 line, querying multiple tables gives 1 line as output.
         HOSP_ADM_KPI_CTE   AS T0 -- Hospital admissions KPI data
        ,IC_ADM_KPI_CTE     AS T1 -- IC admissions KPI data
        ,(
            SELECT * FROM [VWSSTATIC].[RISK_LEVEL_THRESHOLDS] 
            WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSSTATIC].RISK_LEVEL_THRESHOLDS )
         ) AS T2 -- Thresholds to determine levels
        ,RISK_HISTORY_CTE AS T3 -- History to determine valid_from date
)
,
NEW_DATA_CTE AS (
    SELECT * 

        --Add aggregated risk level and validity information

        --Add aggregated risk level: Highest (worst) of both
        ,IIF(RISK_LEVEL_HOSP > RISK_LEVEL_IC, RISK_LEVEL_HOSP, RISK_LEVEL_IC) AS RISK_LEVEL

        --If the risk level does not change, the valid_from date should stay the same
        ,CASE WHEN IIF(RISK_LEVEL_HOSP > RISK_LEVEL_IC, RISK_LEVEL_HOSP, RISK_LEVEL_IC) = HISTORIC_RISK_LEVEL
                THEN HISTORIC_RISK_VALID_FROM
              ELSE CAST(GETDATE() AS DATE) -- Take date of today if risk level is updated
              END AS VALID_FROM
        ,1 AS [VALID] --This column can be set to 0 for erroneous records
    FROM (
        SELECT 

            --Measures
            HOSP_WEEK_START
            ,HOSP_WEEK_END  
            ,HOSP_7D_AVG    
            ,HOSP_INSERTION                     
            ,IC_WEEK_START
            ,IC_WEEK_END  
            ,IC_7D_AVG  
            ,IC_INSERTION

            --Thresholds
            ,[RISK_LEVEL_1]                                         
            ,[RISK_LEVEL_2]                                         
            ,[RISK_LEVEL_3]                                         
            ,[IC_LOWER]                                                 
            ,[IC_UPPER]                                             
            ,[HOSP_LOWER]                                           
            ,[HOSP_UPPER]                                           
            ,[THRESHOLD_VALID_FROM]

            --Historic  
            ,HISTORIC_RISK_LEVEL
            ,HISTORIC_RISK_VALID_FROM

            --Conclusions
            ,CASE WHEN HOSP_7D_AVG >= [HOSP_LOWER] AND  HOSP_7D_AVG <= [HOSP_UPPER] --Risk level 2 thresholds are inclusive
                    THEN 2
                    WHEN HOSP_7D_AVG < [HOSP_LOWER]
                    THEN 1   --Risk level 1 threshold is exclusive
                    WHEN HOSP_7D_AVG > [HOSP_UPPER]
                    THEN 3   --Risk level 3 threshold is exclusive 
                ELSE NULL
                END AS RISK_LEVEL_HOSP
            ,CASE WHEN IC_7D_AVG >= [IC_LOWER] AND  IC_7D_AVG <= [IC_UPPER] --Risk level 2 thresholds are inclusive
                    THEN 2
                    WHEN IC_7D_AVG < [IC_LOWER]
                    THEN 1   --Risk level 1 threshold is exclusive
                    WHEN IC_7D_AVG > [IC_UPPER]
                    THEN 3   --Risk level 3 threshold is exclusive 
                ELSE NULL
                END AS RISK_LEVEL_IC
        FROM KPI_CTE
    ) AS T0
)

INSERT INTO VWSDEST.RISK_LEVEL_NL_HISTORY(

        --Measures
         HOSP_WEEK_START
        ,HOSP_WEEK_END  
        ,HOSP_7D_AVG    
        ,HOSP_INSERTION                     
        ,IC_WEEK_START
        ,IC_WEEK_END  
        ,IC_7D_AVG  
        ,IC_INSERTION

        --Thresholds
        ,[RISK_LEVEL_1]                                         
        ,[RISK_LEVEL_2]                                         
        ,[RISK_LEVEL_3]                                         
        ,[IC_LOWER]                                                 
        ,[IC_UPPER]                                             
        ,[HOSP_LOWER]                                           
        ,[HOSP_UPPER]                                           
        ,[THRESHOLD_VALID_FROM]

        --Conclusions
        ,RISK_LEVEL_HOSP
        ,RISK_LEVEL_IC
        ,RISK_LEVEL
        ,VALID_FROM
        ,VALID
    )

SELECT 

            --Measures
             HOSP_WEEK_START
            ,HOSP_WEEK_END  
            ,HOSP_7D_AVG
            ,HOSP_INSERTION                     
            ,IC_WEEK_START
            ,IC_WEEK_END  
            ,IC_7D_AVG
            ,IC_INSERTION

            --Thresholds
            ,[RISK_LEVEL_1]                                         
            ,[RISK_LEVEL_2]                                         
            ,[RISK_LEVEL_3]                                         
            ,[IC_LOWER]                                                 
            ,[IC_UPPER]                                             
            ,[HOSP_LOWER]                                           
            ,[HOSP_UPPER]                                           
            ,[THRESHOLD_VALID_FROM]
                       
            --Conclusions
            ,RISK_LEVEL_HOSP                                        
            ,RISK_LEVEL_IC                                        
            ,RISK_LEVEL                         
            ,VALID_FROM                                        
            ,VALID                                   

FROM NEW_DATA_CTE


END;