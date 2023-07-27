-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   PROCEDURE DBO.SP_ECDC_VARIANTS_DEST
 AS
 BEGIN
     -- Apply filters and map variants
     WITH ECDC_FILTERED
     AS (
         
         SELECT
             ECDC_VARIANTS.[COUNTRY],
             CC.[COUNTRY_CODE_ISO3]                          AS [COUNTRY_CODE],
             ECDC_VARIANTS.[YEAR_WEEK],
             ECDC_VARIANTS.[SOURCE],
             ECDC_VARIANTS.[NEW_CASES],
             ECDC_VARIANTS.[NUMBER_SEQUENCED]                AS [SAMPLE_SIZE],
             ECDC_VARIANTS.[PERCENT_CASES_SEQUENCED]         AS [PERCENT_CASES_SAMPLED],
             ECDC_VARIANTS.[VALID_DENOMINATOR],
             ECDC_VARIANTS.[VARIANT]                         AS [VARIANT_CODE],
             VariantMapped.WHO_VARIANT                       AS [VARIANT],
 
 
             CASE
                 WHEN LEN([WHO_VARIANT])>0 AND CLASSIFICATION = 'VOC' THEN CAST(1 as bit)
                 ELSE CAST(0 as bit)
             END                                             AS [VARIANT_OF_CONCERN],
 
 
             ECDC_VARIANTS.[NUMBER_DETECTIONS_VARIANT]       AS [OCCURRENCE]
         
         FROM 
         VWSINTER.ECDC_VARIANTS ECDC_VARIANTS
         INNER JOIN -- Inner join country code table (includes all countries) to add ISO 3
             VWSSTATIC.COUNTRY_CODES CC ON
             CC.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.COUNTRY_CODES) AND
             CC.COUNTRY_CODE_ISO2 = 
                 CASE 
                     WHEN ECDC_VARIANTS.[COUNTRY_CODE] = 'EL' THEN 'GR' -- Greece exception, see https://publications.europa.eu/code/pdf/370000en.htm
                     ELSE ECDC_VARIANTS.[COUNTRY_CODE]
                 END
         LEFT JOIN -- Add WHO naming of variant codes
             VWSSTATIC.VARIANTS_MAPPING VariantMapped ON
             VariantMapped.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.VARIANTS_MAPPING) AND
             VariantMapped.VARIANT_CODE = [VARIANT]
         WHERE
             ECDC_VARIANTS.DATE_LAST_INSERTED = (
                 SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.ECDC_VARIANTS
             ) AND
             ECDC_VARIANTS.SOURCE IN ('GISAID', 'TESSy') AND -- GISAID OR TESSy
             ECDC_VARIANTS.VALID_DENOMINATOR = 1 AND -- VALID = True/Yes
             ECDC_VARIANTS.[NUMBER_SEQUENCED] > 0
     ),
     ECDC_SOURCE_SELECTION AS
     (
         -- Select source for country and week with highest number sequenced, Either GISAID OR TESSy, preference for GISAID if equal. 
         SELECT
             [COUNTRY],
             [COUNTRY_CODE],
             [YEAR_WEEK],
             CASE 
                 WHEN SUM(CASE WHEN SOURCE = 'GISAID' THEN SAMPLE_SIZE ELSE 0 END) >= SUM(CASE WHEN SOURCE = 'TESSy' THEN SAMPLE_SIZE ELSE 0 END) THEN 'GISAID'
                 ELSE 'TESSy'
             END                                                         AS [SELECTED_SOURCE]
 
         FROM
             (
                 -- DISTINCT because the ECDC data contains both headers and lines headers (for each country, country code, year week, source, sample_size), lines for each variant : occurance, variant code
                 SELECT DISTINCT
                     [COUNTRY],
                     [COUNTRY_CODE],
                     [YEAR_WEEK],
                     SOURCE,
                     SAMPLE_SIZE              
                 FROM
                     ECDC_FILTERED
                 
             ) UNIQUE_SOURCE_SAMPLES
             GROUP BY
                     [COUNTRY],
                     [COUNTRY_CODE],
                     [YEAR_WEEK]
     )
 
     -- Insert statement to DEST table
     /*
         Why GROUP BY ? : 
             For most cases, no group by is needed. The group by is added that if multiple VARIANT codes (B1XX, B2xx) map to the same WHO variant ('alpha'). 
             based on the variant mapping table the variant codes will be aggregrated with the STRING AGG function (B1XX, B2xx) and the sum of the occurance is used to calculate the percentage.
         
         Note for adding/modifying the select : 
             If you add /change the select, please copy the code to the group by as well (except for the aggregrated columns), such to keep the consistency of the group by aggregration.
     */
 
     INSERT INTO VWSDEST.ECDC_VARIANTS
     (
         COUNTRY,
         COUNTRY_CODE,
         YEAR_WEEK,
         WEEK_START,
         WEEK_END,
         SOURCE,
         NEW_CASES,
         SAMPLE_SIZE,
         ECDC_CATEGORY,
         PERCENT_CASES_SAMPLED,
         VARIANT_CODE,
         VARIANT,
         VARIANT_OF_CONCERN,
         OCCURRENCE,
         PERCENT_VARIANT
     )
     SELECT
         ECDC_VARIANTS.COUNTRY,
         ECDC_VARIANTS.COUNTRY_CODE,
         ECDC_VARIANTS.YEAR_WEEK,
         CAST(
             dbo.CONVERT_ISO_WEEK_TO_DATETIME(CAST(LEFT(ECDC_VARIANTS.YEAR_WEEK,4) as int),CAST(RIGHT(ECDC_VARIANTS.YEAR_WEEK,2) as int))
             as date)                                AS [WEEK_START],                 
         DATEADD(DAY,6,CAST(
             dbo.CONVERT_ISO_WEEK_TO_DATETIME(CAST(LEFT(ECDC_VARIANTS.YEAR_WEEK,4) as int),CAST(RIGHT(ECDC_VARIANTS.YEAR_WEEK,2) as int))
             as date)
                 )                                   AS [WEEK_END],     
         ECDC_VARIANTS.SOURCE,
         ECDC_VARIANTS.NEW_CASES,
         ECDC_VARIANTS.SAMPLE_SIZE,
         
         -- ECDC levels of reliability ECDC category, for reference only.
         CASE
             WHEN ECDC_VARIANTS.SAMPLE_SIZE >=  500
                 THEN 'L1'
             WHEN ECDC_VARIANTS.SAMPLE_SIZE >=  60
                 THEN 'L2'
             WHEN ECDC_VARIANTS.SAMPLE_SIZE >=  1
                 THEN 'L3' 
             ELSE
                 'L4'
         END                                                     AS [ECDC_CATEGORY],
 
         ECDC_VARIANTS.PERCENT_CASES_SAMPLED,
 
         STRING_AGG(ECDC_VARIANTS.VARIANT_CODE, ',')             AS [VARIANT_CODE], -- STRING AGG used in case of n codes to 1 mapped variant (see variant mapping table)
         CASE 
             WHEN LEN([VARIANT]) > 0 
                 THEN [VARIANT]
             ELSE 'Other'
         END                                                     AS [VARIANT],
         [VARIANT_OF_CONCERN],
 
         ISNULL(SUM(OCCURRENCE),0)                               AS [OCCURRENCE],
         ISNULL(CAST(100.0 * CAST(SUM(OCCURRENCE) AS [decimal](8, 3)) / ECDC_VARIANTS.SAMPLE_SIZE AS [decimal](8, 1)),0)
                                                     AS PERCENT_VARIANT
     FROM 
         ECDC_FILTERED ECDC_VARIANTS
     
     INNER JOIN -- Only select the source for country and week with highest sample size (GIAID OR TESSy)
         ECDC_SOURCE_SELECTION ON
         ECDC_SOURCE_SELECTION.SELECTED_SOURCE = ECDC_VARIANTS.SOURCE AND
         ECDC_SOURCE_SELECTION.COUNTRY_CODE = ECDC_VARIANTS.COUNTRY_CODE AND
         ECDC_SOURCE_SELECTION.YEAR_WEEK = ECDC_VARIANTS.YEAR_WEEK
     GROUP BY
         ECDC_VARIANTS.COUNTRY,
         ECDC_VARIANTS.COUNTRY_CODE,
         ECDC_VARIANTS.YEAR_WEEK,
         ECDC_VARIANTS.SOURCE,
         ECDC_VARIANTS.NEW_CASES,
         ECDC_VARIANTS.SAMPLE_SIZE,
         ECDC_VARIANTS.PERCENT_CASES_SAMPLED,
         [VARIANT_OF_CONCERN],
         CASE 
             WHEN LEN([VARIANT]) > 0 
                 THEN [VARIANT]
             ELSE 'Other'
         END
 
 END;