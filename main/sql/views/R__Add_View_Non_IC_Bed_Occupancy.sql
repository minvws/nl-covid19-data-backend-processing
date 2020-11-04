-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER VIEW VWSDEST.V_NON_IC_BED_OCCUPANCY AS
SELECT 
    [DATE_OF_REPORT_UNIX],
    [NON_IC_BEDS_OCCUPIED_COVID] as covid_occupied,
    dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)  AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.HOSPITAL_BED_OCCUPANCY
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM VWSDEST.HOSPITAL_BED_OCCUPANCY);