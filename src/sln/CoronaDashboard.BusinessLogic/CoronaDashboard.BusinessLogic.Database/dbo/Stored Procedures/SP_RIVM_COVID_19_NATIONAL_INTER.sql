-- 1) CREATE STORED PROCEDURE(S).....
 CREATE   PROCEDURE [dbo].[SP_RIVM_COVID_19_NATIONAL_INTER]
  AS
  BEGIN
      -- WITH CTE As (
      --     SELECT
      --         [DATE_FILE],
      --         [DATE_STATISTICS],
      --         [DATE_STATISTICS_TYPE],
      --         [AGEGROUP],
      --         [SEX],
      --         [PROVINCE],
      --         [HOSPITAL_ADMISSION],
      --         [DECEASED],
      --         [WEEK_OF_DEATH],
      --         [MUNICIPAL_HEALTH_SERVICE]
      --     FROM
      --         [VWSSTATIC].[RIVM_COVID_19_CASE_NATIONAL]
      --     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTATIC].[RIVM_COVID_19_CASE_NATIONAL])
      -- )
      INSERT INTO [VWSINTER].[RIVM_COVID_19_CASE_NATIONAL] (
          [DATE_FILE],
          [DATE_STATISTICS],
          [DATE_STATISTICS_TYPE],
          [AGEGROUP],
          [SEX],
          [PROVINCE],
          [HOSPITAL_ADMISSION],
          [DECEASED],
          [WEEK_OF_DEATH],
          [MUNICIPAL_HEALTH_SERVICE]
      )
      SELECT
          [dbo].[TRY_CONVERT_TO_DATETIME]([DATE_FILE]),
          [dbo].[TRY_CONVERT_TO_DATETIME]([DATE_STATISTICS]),
          TRIM([DATE_STATISTICS_TYPE]),
          TRIM([AGEGROUP]),
          TRIM([SEX]),
          TRIM([PROVINCE]),
          TRIM([HOSPITAL_ADMISSION]),
          TRIM([DECEASED]),
          TRIM([WEEK_OF_DEATH]),
          TRIM([MUNICIPAL_HEALTH_SERVICE])
      FROM
          [VWSSTAGE].[RIVM_COVID_19_CASE_NATIONAL]
      WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].[RIVM_COVID_19_CASE_NATIONAL])
      -- UNION ALL
      -- SELECT
      --     [dbo].[TRY_CONVERT_TO_DATETIME]([DATE_FILE]),
      --     [dbo].[TRY_CONVERT_TO_DATETIME]([DATE_STATISTICS]),
      --     TRIM([DATE_STATISTICS_TYPE]),
      --     TRIM([AGEGROUP]),
      --     TRIM([SEX]),
      --     TRIM([PROVINCE]),
      --     TRIM([HOSPITAL_ADMISSION]),
      --     TRIM([DECEASED]),
      --     TRIM([WEEK_OF_DEATH]),
      --     TRIM([MUNICIPAL_HEALTH_SERVICE])
      -- FROM CTE
  END;