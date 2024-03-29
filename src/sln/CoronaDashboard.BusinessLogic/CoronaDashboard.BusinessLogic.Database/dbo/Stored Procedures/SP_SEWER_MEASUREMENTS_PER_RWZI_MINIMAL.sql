﻿-- 1) CREATE VIEW(S)..... 
 CREATE   PROCEDURE [dbo].[SP_SEWER_MEASUREMENTS_PER_RWZI_MINIMAL]
 AS
 BEGIN
 
     INSERT INTO
         [VWSDEST].[SEWER_MEASUREMENTS_PER_RWZI_MINIMAL] (
             DATE_UNIX, 
             DATE_START_UNIX, 
             DATE_END_UNIX,WEEK,
             RWZI_AWZI_CODE,
             RWZI_AWZI_NAME,
             GMCODE,
             RNA_NORMALIZED
         )
     SELECT
         [DATE_MEASUREMENT_UNIX] AS DATE_UNIX
         ,dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_START(dbo.CONVERT_UNIX_TO_DATETIME(DATE_MEASUREMENT_UNIX))) AS DATE_START_UNIX
         ,dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_END(dbo.CONVERT_UNIX_TO_DATETIME(DATE_MEASUREMENT_UNIX))) AS DATE_END_UNIX
         ,dbo.CONVERT_UNIX_TO_ISO_WEEKNUMBER(DATE_MEASUREMENT_UNIX) as WEEK
         ,[RWZI_AWZI_CODE]
         ,[RWZI_AWZI_NAME]
         ,GEBIEDSCODE AS [GMCODE]
         ,RNA_FLOW_PER_100000 AS RNA_NORMALIZED
     FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI T1
     LEFT JOIN VWSSTATIC.RWZI_INHIBITANTS_2021 T2
     ON T1.RWZI_AWZI_CODE = T2.CODE_RWZI
     AND T2.PERCENTAGE != 0
     AND GEBIEDSCODE like 'GM%'
     AND T2.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.RWZI_INHIBITANTS_2021 )
     WHERE T1.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI)
     AND RWZI_AWZI_CODE != '0'
     AND DATE_MEASUREMENT > '2020-01-01'
 END;