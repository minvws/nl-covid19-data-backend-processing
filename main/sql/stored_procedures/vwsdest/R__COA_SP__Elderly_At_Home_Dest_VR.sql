-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER PROCEDURE dbo.SP_Elderly_At_Home_Dest_VR
AS
BEGIN

  INSERT INTO VWSDEST.ELDERLY_AT_HOME_VR
        (
            DATE_OF_REPORT,
            DATE_OF_REPORT_UNIX,
            VRCODE,
            INFECTED_ELDERLY_AT_HOME_DAILY,
			INFECTED_ELDERLY_AT_HOME_DAILY_PER_100K,
            DECEASED_ELDERLY_AT_HOME_DAILY
        )
        SELECT
            DATE_OF_STATISTIC_REPORTED AS DATE_OF_REPORT,
            dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_STATISTIC_REPORTED) AS DATE_OF_REPORT_UNIX,
            SECURITY_REGION_CODE AS VRCODE,
            TOTAL_CASES_REPORTED AS INFECTED_ELDERLY_AT_HOME_DAILY,
			--calculate the infected inhabitants in the region per 100k
			CAST(((CAST(TOTAL_CASES_REPORTED as decimal(10,2)) / INHABITANTS)*100000) as decimal(10,2)) AS INFECTED_ELDERLY_AT_HOME_DAILY_PER_100K,
            TOTAL_DECEASED_REPORTED AS DECEASED_ELDERLY_AT_HOME_DAILY
        FROM VWSINTER.ELDERLY_AT_HOME T1
        LEFT JOIN (SELECT [Code Veiligheidsregio]  AS VRCODE
                         ,[Personen van 70 jaar of ouder in particuliere huishoudens] AS [INHABITANTS]
                    FROM [VWSSTATIC].[CBS_INHABITANTS_ELDERLY_AT_HOME]
                    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSSTATIC].[CBS_INHABITANTS_ELDERLY_AT_HOME])) T2
        ON T1.SECURITY_REGION_CODE=T2.VRCODE
        WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSINTER.ELDERLY_AT_HOME)
        AND DATE_OF_STATISTIC_REPORTED > '1900-01-01 00:00:00.000' --overflow fix
        and VRCODE!=' ' -- slice away unknowns
END;