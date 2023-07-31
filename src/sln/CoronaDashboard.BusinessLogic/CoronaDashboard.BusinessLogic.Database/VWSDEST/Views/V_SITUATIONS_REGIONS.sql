﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE     VIEW [VWSDEST].[V_SITUATIONS_REGIONS]
AS
SELECT dbo.CONVERT_DATETIME_TO_UNIX([DATE_START]) AS DATE_START_UNIX
    ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_END]) AS DATE_END_UNIX
    ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED]) AS DATE_OF_INSERTION_UNIX
    ,VRCODE
    ,HAS_SUFFICIENT_DATA
    ,HOME_AND_VISITS
    ,WORK
    ,SCHOOL_AND_DAY_CARE
    ,HEALTH_CARE
    ,GATHERING
    ,TRAVEL
    ,HOSPITALITY
    ,OTHER
FROM (
    SELECT
        *,
        RANK() OVER (PARTITION BY VRCODE ORDER BY DATE_START DESC) RANKING
    FROM VWSDEST.RIVM_SITUATIONS
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.RIVM_SITUATIONS)
    ) T1
WHERE T1.RANKING = 1