-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE    VIEW [VWSDEST].[V_ECDC_VARIANTS] AS
   WITH NL_CTE AS (
       /*
         Why GROUP BY ? : 
             For most cases, no group by is needed. The group by is added that if multiple VARIANT codes (B1XX, B2xx) map to the same WHO variant ('alpha'). 
             based on the variant mapping table the variant codes will be aggregrated with the STRING AGG function (B1XX, B2xx) and the sum of the occurance is used to calculate the percentage.
         Note for adding/modifying the select : 
             If you add /change the select, please copy the code to the group by as well (except for the aggregrated columns), such to keep the consistency of the group by aggregration.
       */
       SELECT 
           'Netherlands'                                                   AS [COUNTRY]
           ,'NLD'                                                          AS [COUNTRY_CODE]
           ,CAST([DATE_OF_STATISTICS_WEEK_START] as date)                  AS [WEEK_START]
           ,DATEADD(DAY,6,CAST([DATE_OF_STATISTICS_WEEK_START] as date))   AS [WEEK_END]
           ,STRING_AGG([RIVM_MUTATIONS].[VARIANT_CODE], ',')               AS [VARIANT_CODE]
           ,CASE
             WHEN LEN(VARIANTS_MAPPING.[WHO_VARIANT])>0 THEN VARIANT_NAME
             ELSE 'Other'
           END                                                             AS [VARIANT]
           ,[RIVM_MUTATIONS].[DATE_LAST_INSERTED]
           ,CASE -- if variant is named by WHO and classification equals VOC.
             WHEN LEN([VARIANTS_MAPPING].[WHO_VARIANT])>0 AND [VARIANTS_MAPPING].CLASSIFICATION = 'VOC' THEN CAST(1 as bit) 
             ELSE CAST(0 as bit)
           END                                                             AS [VARIANT_OF_CONCERN]
           ,MAX([SAMPLE_SIZE])                                             AS [SAMPLE_SIZE]
           ,SUM([VARIANT_CASES])                                           AS [OCCURRENCE]
           ,CAST(100.0 * SUM([VARIANT_CASES]) / MAX([SAMPLE_SIZE]) as decimal(9,1))
                                                                           AS [PERCENT_VARIANT]   
       FROM [VWSDEST].[RIVM_MUTATIONS]
       LEFT JOIN -- Add mapping to use the same variant scope as ECDC data
         VWSSTATIC.VARIANTS_MAPPING ON
         VARIANTS_MAPPING.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.VARIANTS_MAPPING) AND
         VARIANTS_MAPPING.VARIANT_CODE = RIVM_MUTATIONS.VARIANT_CODE
       WHERE 
         [RIVM_MUTATIONS].[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_MUTATIONS]) AND
         [RIVM_MUTATIONS].[SAMPLE_SIZE] > 0
       GROUP BY
           CAST([DATE_OF_STATISTICS_WEEK_START] as date)                  
           ,DATEADD(DAY,6,CAST([DATE_OF_STATISTICS_WEEK_START] as date))
           ,CASE
             WHEN LEN(VARIANTS_MAPPING.[WHO_VARIANT])>0 THEN VARIANT_NAME
             ELSE 'Other'
           END                       
           ,[RIVM_MUTATIONS].[DATE_LAST_INSERTED]
           ,CASE -- if variant is named by WHO and classification equals VOC.
             WHEN LEN([VARIANTS_MAPPING].[WHO_VARIANT])>0 AND [VARIANTS_MAPPING].CLASSIFICATION = 'VOC' THEN CAST(1 as bit) 
             ELSE CAST(0 as bit)
           END                      
   )
   ,
   INTERNATIONAL_CTE AS (
     SELECT 
         [COUNTRY]
         ,[COUNTRY_CODE]
         ,[WEEK_START]
         ,[WEEK_END]
         ,[VARIANT_CODE]
         ,[VARIANT]
         ,[DATE_LAST_INSERTED]
         ,[VARIANT_OF_CONCERN]
         ,[SAMPLE_SIZE]
         ,[OCCURRENCE]
         ,[PERCENT_VARIANT]
     FROM 
       [VWSDEST].[ECDC_VARIANTS]
     WHERE 
       [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[ECDC_VARIANTS])
       AND COUNTRY_CODE != 'NLD'
   ),
   --Select all rows
   COMBINED_CTE AS (
     SELECT 
       [COUNTRY]
       ,[COUNTRY_CODE]
       ,[WEEK_START]
       ,[WEEK_END]
       ,[VARIANT_CODE]
       ,[VARIANT]
       ,[DATE_LAST_INSERTED]
       ,[VARIANT_OF_CONCERN]
       ,[SAMPLE_SIZE]
       ,[OCCURRENCE]
       ,[PERCENT_VARIANT]
        FROM NL_CTE
     UNION ALL 
     SELECT 
        [COUNTRY]
       ,[COUNTRY_CODE]
       ,[WEEK_START]
       ,[WEEK_END]
       ,[VARIANT_CODE]
       ,[VARIANT]
       ,[DATE_LAST_INSERTED]
       ,[VARIANT_OF_CONCERN]
       ,[SAMPLE_SIZE]
       ,[OCCURRENCE] 
       ,[PERCENT_VARIANT]
       FROM INTERNATIONAL_CTE
   ),
   UNIQUE_WHO_VARIANTS AS (
     SELECT DISTINCT
       WHO_VARIANT AS [VARIANT],
       CASE -- if variant is named by WHO and classification equals VOC.
             WHEN LEN([VARIANTS_MAPPING].[WHO_VARIANT])>0 AND [VARIANTS_MAPPING].CLASSIFICATION = 'VOC' THEN CAST(1 as bit) 
             ELSE CAST(0 as bit)
           END                                                             AS [VARIANT_OF_CONCERN]
     FROM
       VWSSTATIC.VARIANTS_MAPPING
     WHERE
         VARIANTS_MAPPING.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.VARIANTS_MAPPING) AND
         LEN(WHO_VARIANT) > 0
     UNION
     SELECT 'Other', CAST(0 as bit)
   ),
   ALL_VARIANTS_WEEKS_PER_COUNTRY AS (
     SELECT 
       [COUNTRY_CODE]
       ,[WEEK_START]
       ,[WEEK_END]
       ,UNIQUE_WHO_VARIANTS.[VARIANT]
       ,UNIQUE_WHO_VARIANTS.[VARIANT_OF_CONCERN]
       ,MAX([SAMPLE_SIZE])                         AS [SAMPLE_SIZE]
     FROM
       COMBINED_CTE
     CROSS JOIN
       UNIQUE_WHO_VARIANTS
     GROUP BY
        [COUNTRY_CODE]
       ,[WEEK_START]
       ,[WEEK_END]
       ,UNIQUE_WHO_VARIANTS.[VARIANT]
       ,UNIQUE_WHO_VARIANTS.[VARIANT_OF_CONCERN]
   )
     
 
 
 SELECT 
       ALL_VARIANTS_WEEKS_PER_COUNTRY.[COUNTRY_CODE]
       ,LOWER(ALL_VARIANTS_WEEKS_PER_COUNTRY.[VARIANT])                                                  AS [NAME]
       ,dbo.CONVERT_DATETIME_TO_UNIX(ALL_VARIANTS_WEEKS_PER_COUNTRY.[WEEK_START])                        AS [date_start_unix]
       ,dbo.CONVERT_DATETIME_TO_UNIX(ALL_VARIANTS_WEEKS_PER_COUNTRY.[WEEK_END])                          AS [date_end_unix]
       
       ,dbo.CONVERT_DATETIME_TO_UNIX((SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[ECDC_VARIANTS]))  AS [date_of_insertion_unix]
       ,CASE
         WHEN ALL_VARIANTS_WEEKS_PER_COUNTRY.[VARIANT_OF_CONCERN] = 1 
           THEN 'true' 
         ELSE 'false' 
         END                                                                                             AS [is_variant_of_concern]
       ,ALL_VARIANTS_WEEKS_PER_COUNTRY.[SAMPLE_SIZE]                                                     AS [sample_size]
       
       -- reliability indicator, true if higher or equal than 500 samples, else false.
       ,CASE
             WHEN ALL_VARIANTS_WEEKS_PER_COUNTRY.SAMPLE_SIZE >=  500 -- ECDC L1
                 THEN 'true' 
             WHEN ALL_VARIANTS_WEEKS_PER_COUNTRY.SAMPLE_SIZE >=  60 -- ECDC L2
                 THEN 'false'
             WHEN ALL_VARIANTS_WEEKS_PER_COUNTRY.SAMPLE_SIZE >=  1 -- ECDC L3
                 THEN 'false' 
             ELSE -- ECDC L4
                 'false'
         END                                                                                             AS [is_reliable]
 
       ,[OCCURRENCE]                                                                                     AS [occurrence]
       ,[PERCENT_VARIANT]                                                                                AS [percentage]
 
 FROM 
   ALL_VARIANTS_WEEKS_PER_COUNTRY
 LEFT JOIN
   COMBINED_CTE ON
   COMBINED_CTE.[COUNTRY_CODE] = ALL_VARIANTS_WEEKS_PER_COUNTRY.[COUNTRY_CODE] AND
   COMBINED_CTE.[WEEK_START] = ALL_VARIANTS_WEEKS_PER_COUNTRY.[WEEK_START] AND
   COMBINED_CTE.[VARIANT] = ALL_VARIANTS_WEEKS_PER_COUNTRY.[VARIANT]
 --Make sure the last dates of NL and international are aligned
 WHERE 
   ALL_VARIANTS_WEEKS_PER_COUNTRY.WEEK_END <= (SELECT MAX([WEEK_END]) FROM NL_CTE) AND
   ALL_VARIANTS_WEEKS_PER_COUNTRY.WEEK_END <= (SELECT MAX([WEEK_END]) FROM INTERNATIONAL_CTE)