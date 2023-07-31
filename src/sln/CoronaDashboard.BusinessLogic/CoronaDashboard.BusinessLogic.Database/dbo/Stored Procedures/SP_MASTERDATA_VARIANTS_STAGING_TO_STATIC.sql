-- 1) CREATE STORED PROCEDURE(S).....
 CREATE   PROCEDURE [DBO].[SP_MASTERDATA_VARIANTS_STAGING_TO_STATIC]
 AS
 BEGIN
         INSERT INTO [VWSSTATIC].[MASTERDATA_VARIANTS] (
                 [VARIANT_CODE],
                 [SHOWS_ON_VWS_DASHBOARD],
                 [LABEL_EN],
                 [LABEL_NL],
                 [SORT_ORDER],
                 [IS_SUBVARIANT_OF]
         )
         SELECT
                 [VARIANT_CODE],
                 [SHOWS_ON_VWS_DASHBOARD],
                 [LABEL_EN],
                 [LABEL_NL],
                 [SORT_ORDER],
                 [IS_SUBVARIANT_OF]
         FROM [VWSSTAGE].[MASTERDATA_VARIANTS]
         WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].[MASTERDATA_VARIANTS])
 END;