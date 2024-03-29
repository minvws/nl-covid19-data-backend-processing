﻿
 CREATE   PROCEDURE [dbo].[SP_RIVM_DECEASED_DAILY_PER_MUNICIPALITY_ARCHIVED_20221231] AS
 BEGIN
     TRUNCATE TABLE [VWSARCHIVE].[RIVM_DECEASED_DAILY_PER_MUNICIPALITY_ARCHIVED_20221231]
 
     INSERT INTO [VWSARCHIVE].[RIVM_DECEASED_DAILY_PER_MUNICIPALITY_ARCHIVED_20221231] (
         [ID],
         [DATE_OF_REPORT],
         [DATE_OF_REPORT_UNIX],
         [MUNICIPALITY_CODE],
         [OLD_DATE_OF_REPORT],
         [OLD_DATE_OF_REPORT_UNIX],
         [OLD_VALUE],
         [DIFFERENCE],
         [DECEASED_ACTUAL],
         [DECEASED_CUMULATIVE],
         [DATE_LAST_INSERTED],
         [WEEK_START],
         [DECEASED_7D_AVG],
         [WEEK_START_LAG],
         [DECEASED_7D_AVG_LAG]
     )
     SELECT 
         [ID],
         [DATE_OF_REPORT],
         [DATE_OF_REPORT_UNIX],
         [MUNICIPALITY_CODE],
         [OLD_DATE_OF_REPORT],
         [OLD_DATE_OF_REPORT_UNIX],
         [OLD_VALUE],
         [DIFFERENCE],
         [DECEASED_ACTUAL],
         [DECEASED_CUMULATIVE],
         [DATE_LAST_INSERTED],
         [WEEK_START],
         [DECEASED_7D_AVG],
         [WEEK_START_LAG],
         [DECEASED_7D_AVG_LAG]
     FROM [VWSDEST].[RIVM_DECEASED_DAILY_PER_MUNICIPALITY]
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_DECEASED_DAILY_PER_MUNICIPALITY])
 END