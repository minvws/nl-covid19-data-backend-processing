-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER VIEW VWSDEST.V_VWS_VACCINE_ADMINISTERED_EST AS
    SELECT 
        [DATE_START_UNIX]
        ,[DATE_END_UNIX]
        ,[AstraZeneca]                                  AS [astra_zeneca]
        ,[BioNTech/Pfizer]                              AS [pfizer]
    --    ,[CureVac]         AS [cure_vac]
        ,[Janssen]
        ,[Moderna]
    --    ,[Sanofi]
        ,[AstraZeneca] + [BioNTech/Pfizer] + [Moderna] +  [Janssen] AS [total]
        ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) 
                                                        AS DATE_OF_INSERTION_UNIX
    FROM 
        VWSDEST.VWS_VACCINE_ADMINISTERED 
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX ([DATE_LAST_INSERTED]) FROM [VWSDEST].[VWS_VACCINE_ADMINISTERED])
    AND REPORT_STATUS = 'estimated'

