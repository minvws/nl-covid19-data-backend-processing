-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   PROCEDURE [dbo].[SP_ECDC_VARIANTS_INTER]
 AS
 BEGIN
     INSERT INTO VWSINTER.ECDC_VARIANTS
     (
         [COUNTRY],
         [COUNTRY_CODE],
         [YEAR_WEEK],
         [SOURCE],
         [NEW_CASES],
         [NUMBER_SEQUENCED],
         [PERCENT_CASES_SEQUENCED],
         [VALID_DENOMINATOR],
         [VARIANT],
         [NUMBER_DETECTIONS_VARIANT],
         [PERCENT_VARIANT]
     )
      SELECT
         [COUNTRY],
         [COUNTRY_CODE],
         [YEAR_WEEK],
         [SOURCE],
         CASE 
             WHEN [NEW_CASES] = 'NA'
             THEN CAST('' AS INT)
             ELSE CAST(NULLIF([NEW_CASES],'') AS INT)
         END AS NEW_CASES,
         CAST([NUMBER_SEQUENCED] AS INT) AS NUMBER_SEQUENCED,
         CASE 
             WHEN [PERCENT_CASES_SEQUENCED] = 'NA'
             THEN CAST(0 AS decimal(8,3))
            ELSE CAST(NULLIF([PERCENT_CASES_SEQUENCED],'') AS decimal(8,3))
         END AS PERCENT_CASES_SEQUENCED,
         CASE 
             WHEN [VALID_DENOMINATOR] = 'Yes' 
             THEN CAST(1 as bit) 
             ELSE CAST(0 as bit) 
         END AS VALID_DENOMINATOR,
         [VARIANT],
         CAST(NULLIF([NUMBER_DETECTIONS_VARIANT],'') AS INT) AS NUMBER_DETECTIONS_VARIANT,
         ISNULL(TRY_CAST(PERCENT_VARIANT as Decimal(8,3)),0)  AS PERCENT_VARIANT
     FROM 
        VWSSTAGE.ECDC_VARIANTS
     WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.ECDC_VARIANTS)
 END;