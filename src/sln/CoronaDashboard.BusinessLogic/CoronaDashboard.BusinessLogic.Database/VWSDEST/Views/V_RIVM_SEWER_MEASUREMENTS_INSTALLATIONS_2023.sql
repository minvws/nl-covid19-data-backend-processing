-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   VIEW [VWSDEST].[V_RIVM_SEWER_MEASUREMENTS_INSTALLATIONS_2023] AS
    WITH
    SEWER_MEASUREMENTS AS (
        SELECT [ID], [DATE_OF_REPORT], [DATE_MEASUREMENT], [RWZI_AWZI_CODE], [DATE_LAST_INSERTED] FROM [VWSDEST].[RIVM_SEWER_MEASUREMENTS_INSTALLATIONS_2023]
        WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_SEWER_MEASUREMENTS_INSTALLATIONS_2023])
    ),
    MUNICIPALITY_RWZI AS (
        SELECT [ID], [REGIO_CODE] AS [GMCODE], [RWZI_CODE] FROM [VWSSTATIC].[MUNICIPALITY_RWZI_COUPLING]
        WHERE [ACTIEF] = 1
        AND [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTATIC].[MUNICIPALITY_RWZI_COUPLING])
    ),
    TOTAL_INSTALLATION_COUNT AS (
        SELECT 
        [GMCODE],
        COUNT(*) AS [TOTAL_INSTALLATION_COUNT]
        FROM MUNICIPALITY_RWZI
        GROUP BY [GMCODE]
    ),
    SEWER_MEASUREMENTS_MUNICIPALITY AS (
        SELECT sm.[ID], sm.[DATE_OF_REPORT], sm.[DATE_MEASUREMENT], sm.[RWZI_AWZI_CODE] AS [RWZI_CODE], mr.[GMCODE], sm.[DATE_LAST_INSERTED]
        FROM SEWER_MEASUREMENTS sm
        RIGHT JOIN MUNICIPALITY_RWZI mr
        ON sm.[RWZI_AWZI_CODE] = mr.[RWZI_CODE]
    ),
    LATEST_MEASUREMENT_WEEK_PER_MUNICIPALITY AS (
        SELECT
            [GMCODE],
            MAX(DATE_START_UNIX) AS [DATE_START_UNIX],
            MAX(DATE_END_UNIX) AS [DATE_END_UNIX]
        FROM [VWSDEST].[V_RIVM_SEWER_MEASUREMENTS_GM_2023] -- get latest value from other view
        GROUP BY [GMCODE]
    ),
    SEWER_MEASUREMENTS_WEEK_MUNICIPALITY AS (
        SELECT 
            smm.[ID],
            smm.[DATE_OF_REPORT],
            smm.[DATE_MEASUREMENT],
            smm.[RWZI_CODE], smm.[GMCODE],
            smm.[DATE_LAST_INSERTED],
            lmwpm.[DATE_START_UNIX],
            lmwpm.[DATE_END_UNIX]
        FROM SEWER_MEASUREMENTS_MUNICIPALITY smm
        JOIN LATEST_MEASUREMENT_WEEK_PER_MUNICIPALITY lmwpm
        ON smm.[GMCODE] = lmwpm.[GMCODE]
        WHERE smm.[DATE_MEASUREMENT] >= dbo.CONVERT_UNIX_TO_DATETIME(lmwpm.[DATE_START_UNIX])
        AND smm.[DATE_MEASUREMENT] <= dbo.CONVERT_UNIX_TO_DATETIME(lmwpm.[DATE_END_UNIX])
    ),
    GMCODE_SAMPLES AS (
        SELECT
            [GMCODE],
            COUNT([ID]) AS [TOTAL_NUMBER_OF_SAMPLES],
            COUNT(DISTINCT [RWZI_CODE]) AS [SAMPLED_INSTALLATION_COUNT],
            [DATE_START_UNIX],
            [DATE_END_UNIX],
            [DATE_LAST_INSERTED]
        FROM SEWER_MEASUREMENTS_WEEK_MUNICIPALITY
        GROUP BY [GMCODE], [DATE_START_UNIX], [DATE_END_UNIX], [DATE_LAST_INSERTED]
    )
    SELECT
        gs.[GMCODE]                                                                     AS [GMCODE],
        gs.[TOTAL_NUMBER_OF_SAMPLES]                                                    AS [TOTAL_NUMBER_OF_SAMPLES],
        gs.[SAMPLED_INSTALLATION_COUNT]                                                 AS [SAMPLED_INSTALLATION_COUNT],
        tic.[TOTAL_INSTALLATION_COUNT]                                                  AS [TOTAL_INSTALLATION_COUNT],
        gs.[DATE_START_UNIX]                                                            AS [DATE_START_UNIX],
        gs.[DATE_END_UNIX]                                                              AS [DATE_END_UNIX], 
        dbo.CONVERT_DATETIME_TO_UNIX(gs.[DATE_LAST_INSERTED])                           AS [DATE_OF_INSERTION_UNIX]
    FROM GMCODE_SAMPLES gs
    JOIN TOTAL_INSTALLATION_COUNT tic
    ON gs.[GMCODE] = tic.[GMCODE]