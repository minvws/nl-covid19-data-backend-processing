-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   VIEW VWSREPORT.V_PBI_Riool_Veiligheidsregio_per_RWZI
AS
	SELECT
         CAST(dbo.WEEK_START(dbo.CONVERT_UNIX_TO_DATETIME(DATE_MEASUREMENT_UNIX)) AS date)  AS [Week start]
        ,CAST(dbo.WEEK_END(dbo.CONVERT_UNIX_TO_DATETIME(DATE_MEASUREMENT_UNIX)) AS date)    AS [Week einde]
        ,[RWZI_AWZI_CODE]                                                                   AS [RWZI code]
        ,[RWZI_AWZI_NAME]                                                                   AS [RWZI naam]
        ,GEBIEDSCODE                                                                        AS [VeiligheidsregioCode]
        ,RNA_FLOW_PER_100000                                                                AS [RNA flow per 100K]
        ,T1.DATE_LAST_INSERTED                                                              AS [Update datum]
    FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI T1
    LEFT JOIN VWSSTATIC.RWZI_INHIBITANTS_2021 T2
        ON T1.RWZI_AWZI_CODE = T2.CODE_RWZI
        AND T2.PERCENTAGE != 0
        AND GEBIEDSCODE like 'VR%'
        AND T2.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.RWZI_INHIBITANTS_2021 )
    WHERE T1.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.SEWER_MEASUREMENTS_PER_RWZI)
    AND RWZI_AWZI_CODE != '0'
    AND DATE_MEASUREMENT > '2020-01-01'