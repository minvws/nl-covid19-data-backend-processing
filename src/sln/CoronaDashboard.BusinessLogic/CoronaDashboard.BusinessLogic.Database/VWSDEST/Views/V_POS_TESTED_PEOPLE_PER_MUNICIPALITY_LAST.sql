﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSDEST.V_POS_TESTED_PEOPLE_PER_MUNICIPALITY_LAST AS
SELECT 
    DATE_OF_REPORT_UNIX AS DATE_UNIX,
    GMCODE,
    POSITIVE_TESTED_PEOPLE AS INFECTED_PER_100K, 
    TOTAL_POSITIVE_TESTED_PEOPLE AS INFECTED, 
    DATE_OF_INSERTION_UNIX
FROM(
    SELECT 
        [DATE_OF_REPORT_UNIX],
        MUNICIPALITY_CODE AS GMCODE,
        DBO.NO_NEGATIVE_NUMBER_F([INFECTED_DAILY_INCREASE]) AS POSITIVE_TESTED_PEOPLE,
        DBO.NO_NEGATIVE_NUMBER_I([INFECTED_DAILY_TOTAL]) AS TOTAL_POSITIVE_TESTED_PEOPLE,
        dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX,
        RANK() OVER (PARTITION BY MUNICIPALITY_CODE ORDER BY DATE_OF_REPORT_UNIX DESC) AS RANKING
    FROM VWSDEST.POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY
        WHERE DATE_OF_REPORT >=  '2020-03-02 00:00:00.000'
        AND DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) FROM VWSDEST.POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY)) T1
WHERE T1.RANKING =1