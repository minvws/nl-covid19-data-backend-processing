-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER VIEW VWSDEST.V_VWS_VACCINATION_AVAILABILITY AS
SELECT 
     [DATE_START_UNIX]
    ,[DATE_END_UNIX]
    ,[AstraZeneca]     AS [astra_zeneca]
    ,[BioNTech/Pfizer] AS [pfizer]
    ,[CureVac]         AS [cure_vac]
    ,[Janssen]
    ,[Moderna]
    ,[Sanofi]
    ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM
(  
    SELECT *
        ,RANK() OVER (ORDER BY DATE_START) AS DATE_RANK
    FROM [VWSDEST].[VWS_VACCINATION_AVAILABILITY]
      WHERE 
            [DATE_LAST_INSERTED] = (SELECT MAX ([DATE_LAST_INSERTED]) FROM [VWSDEST].[VWS_VACCINATION_AVAILABILITY])
        AND [DATE_END] >= GETDATE() -- Only return this week and following weeks dynamically, irrespective of when the data is loaded.
) T1
  WHERE DATE_RANK <= 6 -- Show only the first six weeks