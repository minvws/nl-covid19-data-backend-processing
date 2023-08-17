-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
CREATE   VIEW [VWSREPORT].[V_PBI_HOSPITAL_NICE_INSCHALING_2] AS

    SELECT DATE_OF_STATISTICS     AS [Datum]
        ,DATE_LAST_INSERTED       AS [Update datum]
        ,MUNICIPALITY_CODE        AS [GemeenteCode]
        ,SECURITY_REGION_CODE     AS [VeiligheidsregioCode]
        ,REPORTED                 AS [Ziekenhuisopnames per meldingsdatum]
        ,HOSPITALIZED             AS [Ziekenhuisopnames per opnamedatum]
    FROM VWSINTER.NICE_HOSPITAL with (nolock)
    WHERE Date_Last_Inserted=(Select Max(Date_Last_Inserted) FROM VWSINTER.NICE_HOSPITAL With (nolock))
        AND DATEDIFF(DAY, DATE_OF_STATISTICS, DATE_LAST_INSERTED) <= 1