

-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

-- View for VR
CREATE    VIEW [VWSDEST].[V_SEWER_MEASUREMENTS_PER_RWZI] AS

WITH Sel As (
  SELECT
            [DATE_UNIX]
        ,   DATE_START_UNIX
        ,   DATE_END_UNIX
        ,   WEEK
        ,   [RWZI_AWZI_CODE]
        ,   [RWZI_AWZI_NAME]
        ,   REGIO_CODE          AS[VRCODE]
        ,   CAST(ROUND(RNA_FLOW_PER_100000,0) as INT) AS RNA_NORMALIZED
        ,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
        ,   Date_Last_Inserted
FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI_GM_VR WITH(NOLOCK)
    WHERE DatePart(WeekDay,DATE_LAST_INSERTED) IN(3, 4, 6)
        AND REGIO_TYPE = 'VR'
)
  SELECT
            [DATE_UNIX]
        ,   DATE_START_UNIX
        ,   DATE_END_UNIX
        ,   WEEK
        ,   [RWZI_AWZI_CODE]
        ,   [RWZI_AWZI_NAME]
        ,   [VRCODE]
        ,   RNA_NORMALIZED
        ,   DATE_OF_INSERTION_UNIX
FROM Sel
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM Sel)