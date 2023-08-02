-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE   PROCEDURE [dbo].[SP_ESCALATIONLEVELS_PER_REGION]
AS
BEGIN
    INSERT INTO VWSDEST.ESCALATIONLEVELS_PER_REGION
    (DATE_OF_REPORT
        ,DATE_OF_REPORT_UNIX
        ,VRCODE
        ,ESCALATION_LEVEL
		,[DATUM_VOLGENDE_INSCHALING]
		,[START_METING]
		,[EINDE_METING]
		,[POS_PER_100K_METING]
		,[ZKH_PER_1000K_METING]
        ,DATE_OF_START_VALIDITY
        ,DATE_OF_END_VALIDITY
		,DATE_LAST_DETERMINED
        )
    SELECT
        DATE_LAST_INSERTED as DATE_OF_REPORT,
        dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_REPORT_UNIX,
        Veiligheidsregio_code,
        [CORONANIVEAU_CODE]
		,CASE WHEN [DATUM_VOLGENDE_INSCHALING] IS NOT NULL AND [DATUM_VOLGENDE_INSCHALING] !='' THEN CONVERT(DATETIME, [DATUM_VOLGENDE_INSCHALING] , 103)
            ELSE NULL
         END AS [DATUM_VOLGENDE_INSCHALING]
		,CASE WHEN [START_METING]IS NOT NULL AND [START_METING] !='' THEN CONVERT(DATETIME, [START_METING] , 103)
            ELSE NULL
         END AS [START_METING]
		,CASE WHEN [EINDE_METING] IS NOT NULL AND [EINDE_METING] !='' THEN CONVERT(DATETIME, [EINDE_METING] , 103)
            ELSE NULL
         END AS [START_METING]
		,[POS_PER_100K_METING]
		,[ZKH_PER_1000K_METING]
        ,case
            when Geldig_vanaf_datum is NOT NULL and Geldig_vanaf_datum != '' then CONVERT(DATETIME, Geldig_vanaf_datum, 103)
            ELSE NULL
        END AS DATE_OF_START_VALIDITY,
        case
            when Geldig_tm_datum is NOT NULL and Geldig_tm_datum != '' then CONVERT(DATETIME, Geldig_tm_datum, 103)
            ELSE NULL
        END AS DATE_OF_END_VALIDITY,
		case
            when [DATUM_INSCHALING]  is NOT NULL and [DATUM_INSCHALING]  != '' then CONVERT(DATETIME, [DATUM_INSCHALING], 103)
            ELSE NULL
        END AS DATE_LAST_DETERMINED
    FROM 
       VWSSTAGE.VWS_CORONALEVEL_REGIONS
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                                  FROM VWSSTAGE.VWS_CORONALEVEL_REGIONS)
END;