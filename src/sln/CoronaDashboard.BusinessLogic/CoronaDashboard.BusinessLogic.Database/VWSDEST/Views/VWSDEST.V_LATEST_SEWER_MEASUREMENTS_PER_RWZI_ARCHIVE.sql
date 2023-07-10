﻿CREATE   VIEW [VWSDEST].[VWSDEST.V_LATEST_SEWER_MEASUREMENTS_PER_RWZI_ARCHIVE] AS
SELECT       * from VWSDEST.SEWER_MEASUREMENTS_PER_RWZI
--            [DATE_MEASUREMENT_UNIX]
--        ,   dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_START(dbo.CONVERT_UNIX_TO_DATETIME(DATE_MEASUREMENT_UNIX))) AS DATE_START_UNIX
--        ,   dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_END(dbo.CONVERT_UNIX_TO_DATETIME(DATE_MEASUREMENT_UNIX))) AS DATE_END_UNIX
--        ,   [RWZI_AWZI_CODE]
--        ,   [RWZI_AWZI_NAME]
--        ,   [VRCODE]
--        ,   [VRNAAM]
--        ,   b.GM_CODE
--        ,   [RNA_NORMALIZED]
--        ,   DATE_OF_INSERTION_UNIX
--FROM (
--SELECT
--             DATE_MEASUREMENT
--        ,   [DATE_MEASUREMENT_UNIX]
--        ,   [RWZI_AWZI_CODE]
--        ,   [RWZI_AWZI_NAME]
--        ,   [VRCODE]
--        ,   [VRNAAM]
--        ,   [RNA_FLOW_PER_100000] AS RNA_NORMALIZED
--        ,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)  AS DATE_OF_INSERTION_UNIX
--        ,   RANK () OVER (PARTITION BY RWZI_AWZI_CODE ORDER BY DATE_MEASUREMENT_UNIX DESC) as RANKING
--FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI
--WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI)) a
--LEFT JOIN VWSSTATIC.RWZI_GMCODE b
--ON b.RWZI_CODE = RWZI_AWZI_CODE
--AND b.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.RWZI_GMCODE )
--WHERE a.RANKING = 1