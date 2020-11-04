-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER VIEW VWSDEST.V_SEWER_MEASUREMENTS_PER_MUNICIPALITY AS
SELECT 
        WEEK_UNIX
    ,   dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_START_FROM_WEEKNUMBER([WEEK])) AS WEEK_START_UNIX
    ,   dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_END_FROM_WEEKNUMBER([WEEK])) AS WEEK_END_UNIX
    ,   GMCODE
    ,   AVERAGE_RNA_FLOW_PER_100000 AS AVERAGE
    ,   NUMBER_OF_LOCATIONS AS TOTAL_INSTALLATION_COUNT
    ,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY 
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY)
-- week_unix is on monday. We can only publish the data of that week after tuesday of next week.
AND GETDATE() > dateadd(day, 8,dateadd(S, WEEK_UNIX, '1970-01-01'))
AND dateadd(S, WEEK_UNIX, '1970-01-01') > '2020-01-01'