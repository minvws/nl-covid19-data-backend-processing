﻿-- Copyright (c) 2021 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSDEST.V_HOSPITAL_ADMISSIONS_OVERTIME_BYAGEGROUP
AS
    SELECT 
         [0-19]																AS [admissions_age_0_19_per_million]
        ,[20-29]															AS [admissions_age_20_29_per_million]
        ,[30-39]															AS [admissions_age_30_39_per_million]
        ,[40-49]															AS [admissions_age_40_49_per_million]
        ,[50-59]															AS [admissions_age_50_59_per_million]
        ,[60-69]															AS [admissions_age_60_69_per_million]
        ,[70-79]															AS [admissions_age_70_79_per_million]
        ,[80-89]															AS [admissions_age_80_89_per_million]
        ,[90+]																AS [admissions_age_90_plus_per_million]
		,[total]															AS [admissions_overall_per_million]
		,dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_STATISTICS_WEEK_START])		AS [date_start_unix]
        ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_STATISTICS_WEEK_END])		AS [date_end_unix]
		,dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED])					AS [date_of_insertion_unix]

    FROM  
		(SELECT   
			[DATE_OF_REPORT]
			,[DATE_LAST_INSERTED]
			,[DATE_OF_STATISTICS_WEEK_START]
			,[DATE_OF_STATISTICS_WEEK_END]
			,[AGE_GROUP_GROUPED]	
			,[HOSPITAL_ADMISSION_PER1M]
			--,[IC_ADMISSION_PER1M]	
		FROM [VWSDEST].[RIVM_HOSPITAL_IC_ADMISSIONS_OVERTIME_BYAGEGROUP] AdmissionsSource
		WHERE [DATE_LAST_INSERTED] = (
			SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_HOSPITAL_IC_ADMISSIONS_OVERTIME_BYAGEGROUP])
		) Admissions
    PIVOT  
    (  
		SUM([HOSPITAL_ADMISSION_PER1M])
		FOR [AGE_GROUP_GROUPED] IN (
			[0-19]
			,[20-29]
			,[30-39]
			,[40-49]
			,[50-59]
			,[60-69]
			,[70-79]
			,[80-89]
			,[90+]
			,[total]
			) 
	) AS PivotTable;