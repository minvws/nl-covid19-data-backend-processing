﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN   VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.
 
 -- 1) CREATE STORE PROCEDURE(S) INTER -> ARCHIVE.....
 CREATE   PROCEDURE [dbo].[SP_RIVM_COVID_19_CASE_NATIONAL_INTER_TO_ARCHIVE] (
     @max_datasets AS [INT] = 0
 )
 AS
 BEGIN
 
     IF @max_datasets = 0 PRINT '>> Maximum number of datasets set to 0, no datasets are archived.'
 
     BEGIN TRANSACTION;
 
         SELECT DISTINCT TOP(@max_datasets)
             [DATE_LAST_INSERTED]
         INTO #DATE_LAST_INSERTIONS
         FROM [VWSINTER].[RIVM_COVID_19_CASE_NATIONAL] 
         WHERE [DATE_LAST_INSERTED] < CONVERT(DATE, DATEADD(DAY, -2, GETDATE()))
 
         SELECT
             [DATE_FILE],
             [DATE_STATISTICS],
             [DATE_STATISTICS_TYPE],
             [AGEGROUP],
             [SEX],
             [PROVINCE],
             [HOSPITAL_ADMISSION],
             [DECEASED],
             [WEEK_OF_DEATH],
             [MUNICIPAL_HEALTH_SERVICE],
             c19cn.[DATE_LAST_INSERTED]
         FROM [VWSINTER].[RIVM_COVID_19_CASE_NATIONAL] c19cn
         INNER JOIN #DATE_LAST_INSERTIONS dli 
             ON dli.[DATE_LAST_INSERTED] = c19cn.[DATE_LAST_INSERTED]
 
         DELETE c19cn
         FROM [VWSINTER].[RIVM_COVID_19_CASE_NATIONAL] c19cn
         INNER JOIN #DATE_LAST_INSERTIONS dli 
             ON dli.[DATE_LAST_INSERTED] = c19cn.[DATE_LAST_INSERTED]
 
         DROP TABLE IF EXISTS #DATE_LAST_INSERTIONS
 
     COMMIT;
 END