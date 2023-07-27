﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSDEST.V_NURSING_HOMES_TOTALS_DECEASED
AS
SELECT 
    [DATE_OF_REPORT_UNIX] AS DATE_UNIX,
    DBO.NO_NEGATIVE_NUMBER_I([DECEASED_NURSERY_DAILY]) AS DECEASED_NURSERY_DAILY,
    dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.NURSING_HOMES_TOTALS
WHERE DATE_OF_REPORT >=  '2020-02-27 00:00:00.000'
AND DATE_OF_REPORT <  (SELECT MAX(DATE_OF_REPORT) FROM VWSDEST.NURSING_HOMES_TOTALS)
AND DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) FROM VWSDEST.NURSING_HOMES_TOTALS)