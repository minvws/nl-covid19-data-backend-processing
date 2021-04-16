-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER  VIEW [VWSDEST].[V_ESCALATIONLEVELS_PER_REGION] AS
SELECT
     VRCODE
    ,ESCALATION_LEVEL                                           AS [LEVEL]
    ,dbo.CONVERT_DATETIME_TO_UNIX([START_METING])               AS [BASED_ON_STATISTICS_FROM_UNIX]
	,dbo.CONVERT_DATETIME_TO_UNIX([EINDE_METING])			    AS [BASED_ON_STATISTICS_TO_UNIX]
	,dbo.CONVERT_DATETIME_TO_UNIX(DATUM_VOLGENDE_INSCHALING)    AS [NEXT_DETERMINED_UNIX]
	,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_DETERMINED)         AS LAST_DETERMINED_UNIX
    ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_START_VALIDITY)       AS VALID_FROM_UNIX
	,POS_PER_100K_METING                AS [POSITIVE_TESTED_PER_100K]
	,ZKH_PER_1000K_METING               AS [HOSPITAL_ADMISSIONS_PER_MILLION]
    ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)           AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.ESCALATIONLEVELS_PER_REGION
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                            FROM VWSDEST.ESCALATIONLEVELS_PER_REGION);