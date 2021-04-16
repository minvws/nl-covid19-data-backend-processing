-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER VIEW VWSDEST.V_VWS_VACCINE_DELIVERIES_WEEKLY AS
SELECT 
     [AstraZeneca]     AS [astra_zeneca]
    ,[BioNTech/Pfizer] AS [bio_n_tech_pfizer]
--      ,[CureVac]         AS [cure_vac]
      ,[Janssen]
      ,[Moderna]
--      ,[Sanofi]
      ,[TOTAL_VALUE] as [total]
      ,IIF([REPORT_STATUS] = 'estimated','true','false') AS is_estimate
      ,[DATE_START_UNIX]
      ,[DATE_END_UNIX]
      ,dbo.CONVERT_DATETIME_TO_ISO_WEEKNUMBER([DATE_FIRST_DAY]) as WEEK_NUMBER
    --   ,ROW_NUMBER() OVER (ORDER BY DATE_START_UNIX) as WEEK_NUMBER
      ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_REPORT) AS DATE_OF_REPORT_UNIX
      ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
  FROM [VWSDEST].[VWS_VACCINE_DELIVERIES_WEEKLY]
  WHERE [DATE_LAST_INSERTED] = (SELECT MAX ([DATE_LAST_INSERTED]) FROM [VWSDEST].[VWS_VACCINE_DELIVERIES_WEEKLY])