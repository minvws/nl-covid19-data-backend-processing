-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE VIEW [VWSDEST].[V_LATEST_SEWER_MEASUREMENTS_PER_RWZI] AS
SELECT       
            [DATE_MEASUREMENT_UNIX]
        ,   dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_START([DATE_MEASUREMENT])) WEEK_START_UNIX
        ,   dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_END([DATE_MEASUREMENT])) WEEK_END_UNIX
        ,   [RWZI_AWZI_CODE]
        ,   [RWZI_AWZI_NAME]
        ,   [VRCODE]
        ,   [VRNAAM]
        ,   b.GM_CODE
        ,   [RNA_PER_ML]
        ,   DATE_OF_INSERTION_UNIX
FROM (
SELECT
             DATE_MEASUREMENT
        ,   [DATE_MEASUREMENT_UNIX]
        ,   [RWZI_AWZI_CODE]
        ,   [RWZI_AWZI_NAME]
        ,   [VRCODE]
        ,   [VRNAAM]
        ,   [RNA_PER_ML]
        ,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)  AS DATE_OF_INSERTION_UNIX
        ,   RANK () OVER (PARTITION BY RWZI_AWZI_CODE ORDER BY DATE_MEASUREMENT_UNIX DESC) as RANKING
FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI)) a
LEFT JOIN VWSSTATIC.RWZI_GMCODE b
ON b.RWZI_CODE = RWZI_AWZI_CODE
WHERE a.RANKING = 1
GO