﻿-- 1) CREATE STORED PROCEDURE(S): STAGING TO STATIC.....
 CREATE   PROCEDURE [dbo].[SP_INSERT_SL_RIVM_VACCINATION_CAMPAIGNS_MASTER_DATA]
 AS
 BEGIN
     INSERT INTO [VWSSTATIC].[RIVM_VACCINATION_CAMPAIGNS_MASTER_DATA] (
         [CAMPAIGN_LABEL_NL],
         [CAMPAIGN_LABEL_EN],
         [CAMPAIGN_CODE],
         [ORDER]
     )
     SELECT
         [CAMPAIGN_LABEL_NL],
         [CAMPAIGN_LABEL_EN],
         [CAMPAIGN_CODE],
         [ORDER]
     FROM
         [VWSSTAGE].[RIVM_VACCINATION_CAMPAIGNS_MASTER_DATA]
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].[RIVM_VACCINATION_CAMPAIGNS_MASTER_DATA])
 END;