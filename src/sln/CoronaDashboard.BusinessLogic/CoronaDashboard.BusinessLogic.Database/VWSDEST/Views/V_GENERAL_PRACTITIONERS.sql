﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW [VWSDEST].[V_GENERAL_PRACTITIONERS] AS
SELECT 
    dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_START(dbo.CONVERT_UNIX_TO_DATETIME(WEEK_UNIX))) AS DATE_START_UNIX,
    dbo.CONVERT_DATETIME_TO_UNIX(dbo.WEEK_END(dbo.CONVERT_UNIX_TO_DATETIME(WEEK_UNIX))) AS DATE_END_UNIX,
    INCIDENTIE AS COVID_SYMPTOMS_PER_100K,
    GESCHAT_AANTAL AS COVID_SYMPTOMS,
    dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.SUSPICIONS_GENERAL_PRACTITIONERS
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.SUSPICIONS_GENERAL_PRACTITIONERS)