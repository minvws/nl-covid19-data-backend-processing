-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER VIEW [VWSDEST].[V_ELDERLY_AT_HOME_REGIONS]
AS
SELECT
[INFECTED_ELDERLY_AT_HOME_DAILY] AS POSITIVE_TESTED_DAILY,
[INFECTED_ELDERLY_AT_HOME_DAILY_PER_100K] AS POSITIVE_TESTED_DAILY_PER_100K,
[DECEASED_ELDERLY_AT_HOME_DAILY] AS DECEASED_DAILY,
[DATE_OF_REPORT_UNIX] AS DATE_UNIX,
dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED]) AS DATE_OF_INSERTION_UNIX,
[VRCODE] as VRCODE
FROM VWSDEST.ELDERLY_AT_HOME_VR
WHERE DATE_OF_REPORT >=  '2020-02-27 00:00:00.000'
AND DATE_OF_REPORT = (SELECT date_of_report from 
(select date_of_report, rank() over (order by date_of_report desc) ranking
FROM (select distinct date_of_report from VWSDEST.ELDERLY_AT_HOME_VR
where DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) FROM VWSDEST.ELDERLY_AT_HOME_VR)) x) y
where ranking = 2)
AND DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) FROM VWSDEST.ELDERLY_AT_HOME_VR)
