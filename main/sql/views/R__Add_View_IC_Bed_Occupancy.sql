-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER VIEW VWSDEST.V_IC_BED_OCCUPANCY AS
SELECT 
    [DATE_OF_REPORT_UNIX],
    [IC_BEDS_OCCUPIED_COVID] as covid_occupied,
    [IC_BEDS_OCCUPIED_NON_COVID] as non_covid_occupied,
    [IC_BEDS_OCCUPIED_COVID_PERCENTAGE] as covid_percentage_of_all_occupied,
    dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)  AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.HOSPITAL_BED_OCCUPANCY
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM VWSDEST.HOSPITAL_BED_OCCUPANCY);