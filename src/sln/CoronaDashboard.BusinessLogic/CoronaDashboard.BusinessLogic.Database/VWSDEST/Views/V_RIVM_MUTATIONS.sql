-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
 
 --File name has _A_ to make sure this file is executed before the view that depends on this.
 CREATE    VIEW [VWSDEST].[V_RIVM_MUTATIONS]
 AS
 
 WITH BASE_CTE AS (
 SELECT [ID]
       ,[DATE_OF_REPORT]
       ,[DATE_OF_STATISTICS_WEEK_START]
       ,[VARIANT_CODE]
       ,[VARIANT_NAME]
       --The following two columns will be used to turn into column names using pivot.
       ,[VARIANT_NAME] + '_IS_VARIANT_OF_CONCERN' AS [PIVOT_IS_VARIANT_OF_CONCERN]
       ,[VARIANT_NAME] + '_OCCURRENCE' AS [PIVOT_OCCURRENCE]
       ,[IS_VARIANT_OF_CONCERN]
       ,[SAMPLE_SIZE]
       ,[VARIANT_CASES] AS [OCCURRENCE]
       ,[VARIANT_PERCENTAGE] AS [PERCENTAGE]
       ,[DATE_LAST_INSERTED]
   FROM [VWSDEST].[RIVM_MUTATIONS]
   WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_MUTATIONS])
 )
 ,
 --This CTE is used to explicitly retrieve the sample size per week.
 SAMPLE_SIZE_CTE AS (
     SELECT 
            MAX([SAMPLE_SIZE]) AS [SAMPLE_SIZE] --Only one value present
           ,[DATE_OF_REPORT] 
           ,[DATE_OF_STATISTICS_WEEK_START] 
     FROM BASE_CTE
         GROUP BY [DATE_OF_REPORT] ,[DATE_OF_STATISTICS_WEEK_START]
 )
 ,
 --CTE pivotting if the variant is of concern per variant
 VARIANT_CTE AS (
 
     SELECT 
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS_WEEK_START],
         [DATE_LAST_INSERTED],  
         Alpha_IS_VARIANT_OF_CONCERN,
         Beta_IS_VARIANT_OF_CONCERN,
         Gamma_IS_VARIANT_OF_CONCERN,
         Delta_IS_VARIANT_OF_CONCERN,
         Epsilon_IS_VARIANT_OF_CONCERN,
         Eta_IS_VARIANT_OF_CONCERN,
         Theta_IS_VARIANT_OF_CONCERN,
         Kappa_IS_VARIANT_OF_CONCERN,
         Lambda_IS_VARIANT_OF_CONCERN,
         Other_IS_VARIANT_OF_CONCERN
     FROM
         (
             SELECT 
                 [DATE_OF_REPORT],
                 [DATE_OF_STATISTICS_WEEK_START],
                 [DATE_LAST_INSERTED],  
                 [PIVOT_IS_VARIANT_OF_CONCERN],
                 [IS_VARIANT_OF_CONCERN]
             FROM BASE_CTE
         ) AS PIVOT_DATA
         PIVOT (
                     MAX([IS_VARIANT_OF_CONCERN]) --Only one value present
                     FOR [PIVOT_IS_VARIANT_OF_CONCERN] IN (
                         Alpha_IS_VARIANT_OF_CONCERN,
                         Beta_IS_VARIANT_OF_CONCERN,
                         Gamma_IS_VARIANT_OF_CONCERN,
                         Delta_IS_VARIANT_OF_CONCERN,
                         Epsilon_IS_VARIANT_OF_CONCERN,
                         Eta_IS_VARIANT_OF_CONCERN,
                         Theta_IS_VARIANT_OF_CONCERN,
                         Kappa_IS_VARIANT_OF_CONCERN,
                         Lambda_IS_VARIANT_OF_CONCERN,
                         Other_IS_VARIANT_OF_CONCERN)
             ) AS P1
 )
 ,
 --CTE pivotting the OCCURRENCE numbers per variant
 OCCURRENCE_CTE AS (
     SELECT 
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS_WEEK_START],  
         Alpha_OCCURRENCE,
         Beta_OCCURRENCE,
         Gamma_OCCURRENCE,
         Delta_OCCURRENCE,
         Epsilon_OCCURRENCE,
         Eta_OCCURRENCE,
         Theta_OCCURRENCE,
         Kappa_OCCURRENCE,
         Lambda_OCCURRENCE,
         Other_OCCURRENCE
     FROM
         (
             SELECT 
                 [DATE_OF_REPORT],
                 [DATE_OF_STATISTICS_WEEK_START],
                 [PIVOT_OCCURRENCE],
                 [OCCURRENCE]
             FROM BASE_CTE
         ) AS PIVOT_DATA
         PIVOT (
                     MAX([OCCURRENCE]) --Only one value present
                     FOR [PIVOT_OCCURRENCE] IN (
                         Alpha_OCCURRENCE,
                         Beta_OCCURRENCE,
                         Gamma_OCCURRENCE,
                         Delta_OCCURRENCE,
                         Epsilon_OCCURRENCE,
                         Eta_OCCURRENCE,
                         Theta_OCCURRENCE,
                         Kappa_OCCURRENCE,
                         Lambda_OCCURRENCE,
                         Other_OCCURRENCE)
             ) AS P1
 )
 
 
 --Final selection
 
 --Lambda is set to NULL as it is not included in the selection (that determines the size of other_variants)
 SELECT 
         [dbo].[CONVERT_DATETIME_TO_UNIX](T0.DATE_OF_STATISTICS_WEEK_START) AS DATE_START_UNIX,
         [dbo].[CONVERT_DATETIME_TO_UNIX](dbo.WEEK_END(T0.DATE_OF_STATISTICS_WEEK_START)) AS DATE_END_UNIX,
         ISNULL(T0.Alpha_IS_VARIANT_OF_CONCERN,  'false') AS Alpha_IS_VARIANT_OF_CONCERN,      
         ISNULL(T0.Beta_IS_VARIANT_OF_CONCERN,   'false') AS Beta_IS_VARIANT_OF_CONCERN,       
         ISNULL(T0.Gamma_IS_VARIANT_OF_CONCERN,  'false') AS Gamma_IS_VARIANT_OF_CONCERN,      
         ISNULL(T0.Delta_IS_VARIANT_OF_CONCERN,  'false') AS Delta_IS_VARIANT_OF_CONCERN,      
         ISNULL(T0.Epsilon_IS_VARIANT_OF_CONCERN,'false') AS Epsilon_IS_VARIANT_OF_CONCERN,        
         ISNULL(T0.Eta_IS_VARIANT_OF_CONCERN,    'false') AS Eta_IS_VARIANT_OF_CONCERN,            
         ISNULL(T0.Theta_IS_VARIANT_OF_CONCERN,  'false') AS Theta_IS_VARIANT_OF_CONCERN,          
         ISNULL(T0.Kappa_IS_VARIANT_OF_CONCERN,  'false') AS Kappa_IS_VARIANT_OF_CONCERN,          
         -- ISNULL(T0.Lambda_IS_VARIANT_OF_CONCERN, 'false') AS Lambda_IS_VARIANT_OF_CONCERN,    
         NULL AS      Lambda_IS_VARIANT_OF_CONCERN,
         ISNULL(T0.Other_IS_VARIANT_OF_CONCERN,  'false') AS Other_IS_VARIANT_OF_CONCERN,          
         ISNULL(T1.Alpha_OCCURRENCE,             0) AS Alpha_OCCURRENCE,                             
         ISNULL(T1.Beta_OCCURRENCE,              0) AS Beta_OCCURRENCE,                          
         ISNULL(T1.Gamma_OCCURRENCE,             0) AS Gamma_OCCURRENCE,                             
         ISNULL(T1.Delta_OCCURRENCE,             0) AS Delta_OCCURRENCE,                     
         ISNULL(T1.Epsilon_OCCURRENCE,           0) AS Epsilon_OCCURRENCE,                           
         ISNULL(T1.Eta_OCCURRENCE,               0) AS Eta_OCCURRENCE,                               
         ISNULL(T1.Theta_OCCURRENCE,             0) AS Theta_OCCURRENCE,                         
         ISNULL(T1.Kappa_OCCURRENCE,             0) AS Kappa_OCCURRENCE,                                 
         -- ISNULL(T1.Lambda_OCCURRENCE,            0) AS Lambda_OCCURRENCE,       
         NULL AS      Lambda_OCCURRENCE,                       
         ISNULL(T1.Other_OCCURRENCE,             0) AS Other_OCCURRENCE,                         
         --Calculate the percentage by using sample size.
         --Recalculating it here requires less code than another pivot.
         ISNULL(ROUND(CAST(T1.Alpha_OCCURRENCE     * 100 AS FLOAT) / T2.[SAMPLE_SIZE],1),0) AS ALPHA_PERCENTAGE,
         ISNULL(ROUND(CAST(T1.Beta_OCCURRENCE      * 100 AS FLOAT) / T2.[SAMPLE_SIZE],1),0) AS BETA_PERCENTAGE,
         ISNULL(ROUND(CAST(T1.Gamma_OCCURRENCE     * 100 AS FLOAT) / T2.[SAMPLE_SIZE],1),0) AS GAMMA_PERCENTAGE,
         ISNULL(ROUND(CAST(T1.Delta_OCCURRENCE     * 100 AS FLOAT) / T2.[SAMPLE_SIZE],1),0) AS DELTA_PERCENTAGE,
         ISNULL(ROUND(CAST(T1.Epsilon_OCCURRENCE   * 100 AS FLOAT) / T2.[SAMPLE_SIZE],1),0) AS EPSILON_PERCENTAGE,
         ISNULL(ROUND(CAST(T1.Eta_OCCURRENCE       * 100 AS FLOAT) / T2.[SAMPLE_SIZE],1),0) AS ETA_PERCENTAGE,
         ISNULL(ROUND(CAST(T1.Theta_OCCURRENCE     * 100 AS FLOAT) / T2.[SAMPLE_SIZE],1),0) AS THETA_PERCENTAGE,
         ISNULL(ROUND(CAST(T1.Kappa_OCCURRENCE     * 100 AS FLOAT) / T2.[SAMPLE_SIZE],1),0) AS KAPPA_PERCENTAGE,
         -- ISNULL(ROUND(CAST(T1.Lambda_OCCURRENCE    * 100 AS FLOAT) / T2.[SAMPLE_SIZE],1),0) AS LAMBDA_PERCENTAGE,
         NULL AS      LAMBDA_PERCENTAGE,
         ISNULL(ROUND(CAST(T1.Other_OCCURRENCE     * 100 AS FLOAT) / T2.[SAMPLE_SIZE],1),0) AS OTHER_PERCENTAGE,
 
         T2.SAMPLE_SIZE,
         [dbo].[CONVERT_DATETIME_TO_UNIX](T0.DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
 FROM VARIANT_CTE T0
     LEFT JOIN OCCURRENCE_CTE T1 ON T0.[DATE_OF_REPORT] = T1.[DATE_OF_REPORT] AND T0.[DATE_OF_STATISTICS_WEEK_START] = T1.[DATE_OF_STATISTICS_WEEK_START]
     LEFT JOIN SAMPLE_SIZE_CTE T2 ON T0.[DATE_OF_REPORT] = T2.[DATE_OF_REPORT] AND T0.[DATE_OF_STATISTICS_WEEK_START] = T2.[DATE_OF_STATISTICS_WEEK_START]