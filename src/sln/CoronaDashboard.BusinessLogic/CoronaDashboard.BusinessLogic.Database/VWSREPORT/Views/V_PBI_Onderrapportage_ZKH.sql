-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW [VWSREPORT].[V_PBI_Onderrapportage_ZKH] 
AS
  SELECT 
    CAST([DATE_LAST_INSERTED] as date)                 AS [Update datum]   
    ,[load_moment]
    ,[std]
    ,[mean]
    ,[start_load_times]
    ,[end_load_times]
    ,[time_range_days_rounded]
    ,[TARGET_TABLE]
    ,[COL_VALUE]
  FROM
    [VWSANALYTICS].[ONDERRAPORTAGE_RESULTS]
    WHERE DATE_LAST_INSERTED in (
		SELECT MAX(DATE_LAST_INSERTED)
		FROM [VWSANALYTICS].[ONDERRAPORTAGE_RESULTS]
		GROUP BY CAST([DATE_LAST_INSERTED] as date), COL_VALUE
	)