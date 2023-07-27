﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE    VIEW [VWSDEST].[V_ELDERLY_AT_HOME_VR]
AS
SELECT
[INFECTED_ELDERLY_AT_HOME_DAILY] AS POSITIVE_TESTED_DAILY,
[7D_AVERAGE_INFECTED_ELDERLY_AT_HOME_DAILY] AS positive_tested_daily_moving_average,
[INFECTED_ELDERLY_AT_HOME_DAILY_PER_100K] AS POSITIVE_TESTED_DAILY_PER_100K,
[DECEASED_ELDERLY_AT_HOME_DAILY] AS DECEASED_DAILY,
[7D_AVERAGE_DECEASED_ELDERLY_AT_HOME_DAILY] AS deceased_daily_moving_average,
[DATE_OF_REPORT_UNIX] AS DATE_UNIX,
dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED]) AS DATE_OF_INSERTION_UNIX,
[VRCODE] as VRCODE
FROM VWSDEST.ELDERLY_AT_HOME_VR WITH(NOLOCK)
WHERE DATE_OF_REPORT >=  '2020-02-27 00:00:00.000'
AND DATE_OF_REPORT <  (SELECT MAX(DATE_OF_REPORT) FROM VWSDEST.ELDERLY_AT_HOME_VR WITH(NOLOCK))
AND DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) FROM VWSDEST.ELDERLY_AT_HOME_VR WITH(NOLOCK))