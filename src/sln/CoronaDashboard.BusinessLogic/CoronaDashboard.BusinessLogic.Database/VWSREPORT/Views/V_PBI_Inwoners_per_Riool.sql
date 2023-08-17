-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSREPORT.V_PBI_Inwoners_per_Riool
AS
    SELECT
         [CODE_RWZI]          AS [Zuiveringsinstallatie Code]
        ,[NAME_RWZI]          AS [Zuiveringsinstallatie]
        ,[INHABITANTS]        AS [Inwoners]
        ,[GEBIEDSCODE]        AS [VeiligheidsregioCode]
        ,[PERCENTAGE]         AS [Inwoner percentage]
        ,CAST([DATE_LAST_INSERTED] as date)     AS [Update datum]
    FROM [VWSSTATIC].[RWZI_INHIBITANTS_2021]
    WHERE 
        [DATE_LAST_INSERTED] =
            (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSSTATIC].[RWZI_INHIBITANTS_2021])