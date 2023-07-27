-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
 
 CREATE   PROCEDURE [dbo].[SP_RIVM_MUTATIONS_INTER]
 AS
 BEGIN
     INSERT INTO VWSINTER.RIVM_MUTATIONS
     (
        [VERSION],
        [DATE_OF_REPORT],
        [DATE_OF_STATISTICS_WEEK_START],
        [VARIANT_CODE],
        [VARIANT_NAME],
        [ECDC_CATEGORY],
        [SAMPLE_SIZE],
        [VARIANT_CASES]
     )
     SELECT
         CAST(ISNULL(NULLIF([VERSION], ''), 0) AS INT)               AS [VERSION],
         CONVERT(DATETIME, [DATE_OF_REPORT], 120)                    AS [DATE_OF_REPORT],
         CONVERT(DATETIME, [DATE_OF_STATISTICS_WEEK_START], 120)     AS [DATE_OF_STATISTICS_WEEK_START],
         [VARIANT_CODE],
         [VARIANT_NAME],
         [ECDC_CATEGORY],
         CAST(SAMPLE_SIZE AS INT),
         CAST(VARIANT_CASES AS INT)
     FROM 
        VWSSTAGE.RIVM_MUTATIONS
     WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.RIVM_MUTATIONS)
 END;