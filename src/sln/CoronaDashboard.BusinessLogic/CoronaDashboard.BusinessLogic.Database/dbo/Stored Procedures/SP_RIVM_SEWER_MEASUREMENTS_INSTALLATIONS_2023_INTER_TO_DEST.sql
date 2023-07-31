-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 -- 1) CREATE STORE PROCEDURE(S) STAGE -> INTER.....
 CREATE   PROCEDURE [DBO].[SP_RIVM_SEWER_MEASUREMENTS_INSTALLATIONS_2023_INTER_TO_DEST]
 AS
 BEGIN
     INSERT INTO [VWSDEST].[RIVM_SEWER_MEASUREMENTS_INSTALLATIONS_2023] (
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_MEASUREMENT],
         [RWZI_AWZI_CODE],
         [RWZI_AWZI_NAME],
         [RNA_FLOW_PER_100000]
     )
     SELECT
         [VERSION],
         [DATE_OF_REPORT],
         [DATE_MEASUREMENT],
         [RWZI_AWZI_CODE],
         [RWZI_AWZI_NAME],
         [RNA_FLOW_PER_100000]
     FROM 
         [VWSINTER].[RIVM_SEWER_MEASUREMENTS_INSTALLATIONS_2023]
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[RIVM_SEWER_MEASUREMENTS_INSTALLATIONS_2023])
 END;