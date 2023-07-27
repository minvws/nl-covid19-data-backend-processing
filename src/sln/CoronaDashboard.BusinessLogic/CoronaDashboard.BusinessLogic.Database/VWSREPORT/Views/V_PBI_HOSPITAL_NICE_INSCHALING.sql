-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
CREATE   VIEW [VWSREPORT].[V_PBI_HOSPITAL_NICE_INSCHALING] AS

    SELECT A.DATE_OF_STATISTICS     AS [Datum]
        ,A.DATE_LAST_INSERTED       AS [Update datum]
        ,A.MUNICIPALITY_CODE        AS [GemeenteCode]
        ,A.SECURITY_REGION_CODE     AS [VeiligheidsregioCode]
        ,B.REPORTED                 AS [Ziekenhuisopnames per meldingsdatum]
        ,B.HOSPITALIZED             AS [Ziekenhuisopnames per opnamedatum]
    FROM (
        -- Select for each calender date the right DATE_LAST_INSERTED
        SELECT  MAX([DATE_LAST_INSERTED]) AS DATE_LAST_INSERTED
        ,MAX(DATE_OF_STATISTICS) AS DATE_OF_STATISTICS
        ,MUNICIPALITY_CODE
        ,SECURITY_REGION_CODE
        FROM [VWSINTER].[NICE_HOSPITAL]
        -- Only allow ingestions after daily run
        WHERE CONVERT(time, DATE_LAST_INSERTED) >= '12:00:00.0000000'
        -- For each GM, take newest run per day
        GROUP BY CONVERT(date, DATE_LAST_INSERTED), MUNICIPALITY_CODE, SECURITY_REGION_CODE
        ) A
    -- Join reported and hospitalized data for each day
    LEFT JOIN [VWSINTER].[NICE_HOSPITAL] B
        ON A.DATE_LAST_INSERTED = B.DATE_LAST_INSERTED
        AND A.DATE_OF_STATISTICS = B.DATE_OF_STATISTICS
        AND A.MUNICIPALITY_CODE = B.MUNICIPALITY_CODE
        AND A.SECURITY_REGION_CODE = B.SECURITY_REGION_CODE
    WHERE DATEDIFF(DAY, A.DATE_OF_STATISTICS, A.DATE_LAST_INSERTED) <= 1