-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW [VWSREPORT].[V_PBI_Gedrag]
AS 
	SELECT
		   CAST([DATE_OF_REPORT] as date)					AS [Rapportage datum]
		   ,CAST([DATE_LAST_INSERTED] as date)     			AS [Update datum]
		  ,CAST([DATE_OF_MEASUREMENT] as date)				AS [Datum]
		  ,[WAVE]											AS [Wave]
		  ,[REGION_CODE]									AS [Regio Code]
		  ,[REGION_NAME]									AS [Regio]
		  ,[SUBGROUP_CATEGORY]								AS [Subgroep categorie]
		  ,[SUBGROUP]										AS [Subgroep]
		  ,REPLACE([INDICATOR_CATEGORY], '_', ' ')			AS [Indicator categorie]
		  ,REPLACE([INDICATOR], '_', ' ')					AS [Indicator]
		  ,[SAMPLE_SIZE]									AS [Steekproef grootte]
		  ,[FIGURE_TYPE]									AS [Eenheid]
		  ,CASE
			WHEN [FIGURE_TYPE] = 'Percentage' THEN [VALUE]/100 
			ELSE [VALUE]
			END												AS [Waarde]
		  ,[LOWER_LIMIT]									AS [Ondergrens]
		  ,[UPPER_LIMIT]									AS [Bovengrens]
		  --,[CHANGE_WRT_PREVIOUS_MEASUREMENT]
		  --,[DATE_LAST_INSERTED]
	  FROM [VWSINTER].[VWS_BEHAVIOR]
	  WHERE 
		[DATE_LAST_INSERTED] = (
			SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[VWS_BEHAVIOR]
		)