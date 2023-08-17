CREATE   VIEW VWSDEST.V_VWS_VACCINE_ADMINISTERED AS
 SELECT 
      [DATE_START_UNIX]
     ,[DATE_END_UNIX]
     ,[AstraZeneca]     AS [astra_zeneca]
     ,[BioNTech/Pfizer] AS [pfizer]
 --    ,[CureVac]         AS [cure_vac]
     ,[Janssen]
     ,[Moderna]
     ,[Novavax]
 --    ,[Sanofi]
     ,[AstraZeneca] + [BioNTech/Pfizer] + [Moderna]  + [Janssen] + [Novavax]   AS [total]
     ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)   AS DATE_OF_INSERTION_UNIX
 FROM VWSDEST.VWS_VACCINE_ADMINISTERED 
   WHERE [DATE_LAST_INSERTED] = (SELECT MAX ([DATE_LAST_INSERTED]) FROM [VWSDEST].[VWS_VACCINE_ADMINISTERED])
   AND REPORT_STATUS = 'reported'