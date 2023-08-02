-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.


CREATE   VIEW VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_REGION_REL AS 
SELECT
    [dbo].[CONVERT_DATETIME_TO_UNIX]([DATE_RANGE_START])    AS [DATE_START_UNIX],
    DATE_OF_REPORT_UNIX                                     AS [DATE_END_UNIX],
    VRCODE,
    ROUNDED_REPORTED_PER_REGION_100000_LAST_WEEK            AS [INFECTED_PER_100K],
    dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)        AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.RESULTS_PER_REGION
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM VWSDEST.RESULTS_PER_REGION)
        AND DATE_RANGE_START IS NOT NULL --Only records with 7 days of history