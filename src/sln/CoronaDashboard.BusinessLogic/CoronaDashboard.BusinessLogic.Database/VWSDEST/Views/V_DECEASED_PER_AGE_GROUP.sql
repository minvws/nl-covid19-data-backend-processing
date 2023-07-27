﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   VIEW [VWSDEST].[V_DECEASED_PER_AGE_GROUP]
AS
SELECT 
     AGEGROUP AS AGE_GROUP_RANGE
    ,CAST(INHABITANTS_PERCENTAGE/100 AS NUMERIC(10,3)) AS AGE_GROUP_PERCENTAGE
    ,CAST(DEATHS_PERCENTAGE/100 AS NUMERIC(10,3)) AS COVID_PERCENTAGE
    ,[DBO].[CONVERT_DATETIME_TO_UNIX](DATE_LAST_INSERTED)  AS DATE_OF_INSERTION_UNIX

FROM [VWSDEST].[DECEASED_PER_AGE_GROUP]
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[DECEASED_PER_AGE_GROUP])