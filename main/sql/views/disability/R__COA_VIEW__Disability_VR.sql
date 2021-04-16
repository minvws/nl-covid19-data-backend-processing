-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER VIEW VWSDEST.V_DISABILITY_VR
AS
SELECT
[INFECTED_DISABILITY_DAILY] AS newly_infected_people,
[TOTAL_NEW_INFECTED_LOCATIONS] AS newly_infected_locations,
[TOTAL_INFECTED_LOCATIONS] AS infected_locations_total,
[PERCENTAGE_INFECTED_LOCATIONS] AS infected_locations_percentage,
[DECEASED_DISABILITY_DAILY] AS deceased_daily,
[DATE_OF_REPORT_UNIX] AS date_unix,
dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED]) AS date_of_insertion_unix,
[VRCODE] as vrcode
FROM VWSDEST.DISABILITY_VR
WHERE DATE_OF_REPORT >=  '2020-02-27 00:00:00.000'
AND DATE_OF_REPORT <  (SELECT MAX(DATE_OF_REPORT) FROM VWSDEST.DISABILITY_VR)
AND DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) FROM VWSDEST.DISABILITY_VR)