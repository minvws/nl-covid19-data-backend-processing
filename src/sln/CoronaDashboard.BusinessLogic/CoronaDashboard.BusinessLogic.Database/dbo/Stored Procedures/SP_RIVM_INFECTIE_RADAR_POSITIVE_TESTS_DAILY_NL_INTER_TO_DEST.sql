﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.
 
 -- 1) CREATE STORE PROCEDURE(S) INTER -> DEST.....
 CREATE   PROCEDURE [DBO].[SP_RIVM_INFECTIE_RADAR_POSITIVE_TESTS_DAILY_NL_INTER_TO_DEST]
 AS
 BEGIN
     INSERT INTO [VWSDEST].[RIVM_INFECTIE_RADAR_POSITIVE_TESTS_DAILY_NL] (
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS],
         [N_PARTICIPANTS_TOTAL],
         [N_WITH_SYMPTOMS],
         [N_WITH_SHARED_COVID_TEST_RESULT],
         [N_TESTED_POSITIVE],
         [PERC_COVID_TEST_POSITIVE]
     )
     SELECT 
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_OF_STATISTICS],
         [N_PARTICIPANTS_TOTAL],
         [N_WITH_SYMPTOMS],
         [N_WITH_SHARED_COVID_TEST_RESULT],
         [N_TESTED_POSITIVE],
         [PERC_COVID_TEST_POSITIVE]
     FROM [VWSINTER].[RIVM_INFECTIE_RADAR_POSITIVE_TESTS_DAILY_NL] 
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[RIVM_INFECTIE_RADAR_POSITIVE_TESTS_DAILY_NL])
 END