-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW [VWSREPORT].[V_PBI_Leeftijdsgroepen] 
AS

    SELECT 
        [AGEGROUP]                              AS [Leeftijdsgroep]
        ,CAST([INHABITANTS] as int)             AS [Inwoners]
        ,[INHABITANTS_PERCENTAGE]               AS [Inwoners percentage]
        ,CAST([DATE_LAST_INSERTED] as date)     AS [Update datum]
    FROM [VWSSTATIC].[CBS_AGEGROUP_DISTRIBUTION]
    WHERE 
        DATE_LAST_INSERTED = 
            (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSSTATIC].[CBS_AGEGROUP_DISTRIBUTION])