-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER VIEW [VWSDEST].[V_RIVM_VACCINE_STOCK] AS
WITH TOTAL_STOCK_CTE AS
(
	SELECT
		 ISNULL([BioNTech/Pfizer],0) + ISNULL([Moderna],0) + ISNULL([AstraZeneca],0) + ISNULL([Janssen],0)			AS [total]
		,[BioNTech/Pfizer]										AS [bio_n_tech_pfizer]
		,[Moderna]												AS [moderna]
		,[AstraZeneca]											AS [astra_zeneca]
		,[Janssen]											    AS [janssen]
		,dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED])		AS [date_of_insertion_unix]
		,dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_STATISTICS])		AS [date_unix]
	FROM   
	(
		SELECT total_stock, vaccine_name, date_of_statistics, DATE_LAST_INSERTED
		FROM 
			[VWSINTER].[RIVM_VACCINE_STOCK]
		WHERE
			[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[RIVM_VACCINE_STOCK]) AND
			YEAR(DATE_OF_STATISTICS) > 1900
		) vaccine_stock_pivot 
	PIVOT  
	(SUM(total_stock) FOR vaccine_name IN   
		([BioNTech/Pfizer],[Moderna],[AstraZeneca],[Janssen])  
	)AS unpvt
)
,
AVAILABLE_CTE AS
(
	SELECT
		ISNULL([BioNTech/Pfizer],0) + ISNULL([Moderna],0) + ISNULL([AstraZeneca],0) + ISNULL([Janssen],0)			AS [total]
		,[BioNTech/Pfizer]										AS [bio_n_tech_pfizer]
		,[Moderna]												AS [moderna]
		,[AstraZeneca]											AS [astra_zeneca]
		,[Janssen]											    AS [janssen]
		,dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED])		AS [date_of_insertion_unix]
		,dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_STATISTICS])		AS [date_unix]
	FROM   
	(
		SELECT free_stock, vaccine_name, date_of_statistics, DATE_LAST_INSERTED  --Change total_stock to the new column containing available doses
		FROM 
			[VWSINTER].[RIVM_VACCINE_STOCK]
		WHERE
			[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[RIVM_VACCINE_STOCK]) AND
			YEAR(DATE_OF_STATISTICS) > 1900
		) vaccine_stock_pivot 
	PIVOT  
	(SUM(free_stock) FOR vaccine_name IN   --Change total_stock to the new column containing available doses
		([BioNTech/Pfizer],[Moderna],[AstraZeneca],[Janssen])  
	)AS unpvt
)
SELECT 
		 T0.[total]
		,T0.[bio_n_tech_pfizer]         AS bio_n_tech_pfizer_total
		,T0.[moderna]                   AS moderna_total
		,T0.[astra_zeneca]              AS astra_zeneca_total
		,T0.[janssen]                   AS janssen_total
		,T1.[total]                     AS total_available
		,T1.[bio_n_tech_pfizer]         AS bio_n_tech_pfizer_available
		,T1.[moderna]                   AS moderna_available
		,T1.[astra_zeneca]              AS astra_zeneca_available
		,T1.[janssen]                   AS janssen_available
        ,T0.[total] - T1.[total]                            AS total_not_available
		,T0.[bio_n_tech_pfizer] - T1.[bio_n_tech_pfizer]    AS bio_n_tech_pfizer_not_available
		,T0.[moderna] - T1.[moderna]                        AS moderna_not_available
		,T0.[astra_zeneca] - T1.[astra_zeneca]              AS astra_zeneca_not_available
		,T0.[janssen] - T1.[janssen]                        AS janssen_not_available
		,T0.[date_of_insertion_unix]
		,T0.[date_unix]
FROM TOTAL_STOCK_CTE T0
JOIN AVAILABLE_CTE T1 
    ON  T0.date_of_insertion_unix = T1.date_of_insertion_unix AND T0.date_unix = T1.date_unix
GO