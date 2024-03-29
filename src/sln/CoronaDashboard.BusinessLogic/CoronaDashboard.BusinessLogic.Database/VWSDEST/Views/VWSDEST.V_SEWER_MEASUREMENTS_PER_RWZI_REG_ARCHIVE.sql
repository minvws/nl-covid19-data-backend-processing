﻿CREATE   VIEW [VWSDEST].[VWSDEST.V_SEWER_MEASUREMENTS_PER_RWZI_REG_ARCHIVE] AS
SELECT * FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI
--            [DATE_MEASUREMENT_UNIX]
--        ,   dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_START(dbo.CONVERT_UNIX_TO_DATETIME(DATE_MEASUREMENT_UNIX))) AS DATE_START_UNIX
--        ,   dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_END(dbo.CONVERT_UNIX_TO_DATETIME(DATE_MEASUREMENT_UNIX))) AS DATE_END_UNIX
--        ,    dbo.CONVERT_UNIX_TO_ISO_WEEKNUMBER(DATE_MEASUREMENT_UNIX) as WEEK
--        ,   [RWZI_AWZI_CODE]
--        ,   [RWZI_AWZI_NAME]
--        ,   T2.GM_CODE AS GMCODE
--        ,   [VRCODE]
--        ,   [VRNAAM]
--        ,   RNA_FLOW_PER_100000 AS RNA_NORMALIZED
--        ,   dbo.CONVERT_DATETIME_TO_UNIX(T1.DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
--FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI T1
--LEFT JOIN VWSSTATIC.RWZI_GMCODE T2
--ON T2.RWZI_CODE = T1.[RWZI_AWZI_CODE]
--AND T2.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.RWZI_GMCODE )
--WHERE T1.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI)
--AND RWZI_AWZI_CODE != '0'
--AND GM_CODE IS NOT NULL
--AND DATE_MEASUREMENT > '2020-01-01'