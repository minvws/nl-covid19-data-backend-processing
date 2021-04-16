-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Create view for pulling infected people per age group
CREATE OR ALTER VIEW VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME AS
/****** Script for SelectTopNRows command from SSMS  ******/

    WITH TotalCasesOverTime ([DATE], DATE_UNIX, TOTAL_CASES, [TOTAL_CASES_7D_MOVING_AVERAGE], [TOTAL_CASES_7D_MOVING_AVERAGE_100K]) AS 
        (SELECT   
            [DATE]
            ,[DATE_UNIX]
            
            ,CASES								AS [TOTAL_CASES]
            ,AVG([CASES]) OVER (				
					ORDER BY 
						TotalCasesDaily.[DATE] ASC 
					ROWS 6 PRECEDING)			AS [TOTAL_CASES_7D_MOVING_AVERAGE]

            ,(
				100000.0 / 
				-- Inhabitants total NL
                (
					SELECT SUM(CAST(INHABITANTS as decimal(19,3))) 
					FROM [VWSSTATIC].[CBS_AGEGROUP_DISTRIBUTION]
					WHERE AGEGROUP IS NULL AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSSTATIC].[CBS_AGEGROUP_DISTRIBUTION])
				)
			) * 
				AVG([CASES]) OVER (				
					ORDER BY 
						TotalCasesDaily.[DATE] ASC 
					ROWS 6 PRECEDING)			AS [TOTAL_CASES_7D_MOVING_AVERAGE_100K]	

        FROM 
            (SELECT 
                [DATE]
                ,[DATE_UNIX]
                ,CAST(SUM(CASES) as decimal) AS [CASES]
            FROM
                [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME] 
            WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME])
            GROUP BY
                [DATE]
                ,[DATE_UNIX]) TotalCasesDaily
    )

    -- Pivot table with one row and five columns  
    SELECT 
         CAST(ROUND(ISNULL([0-9]  ,0),1) AS decimal(19,1))						AS [infected_age_0_9_per_100k]																
        ,CAST(ROUND(ISNULL([10-19],0),1) AS decimal(19,1))						AS [infected_age_10_19_per_100k]
        ,CAST(ROUND(ISNULL([20-29],0),1) AS decimal(19,1))						AS [infected_age_20_29_per_100k]
        ,CAST(ROUND(ISNULL([30-39],0),1) AS decimal(19,1))						AS [infected_age_30_39_per_100k]
        ,CAST(ROUND(ISNULL([40-49],0),1) AS decimal(19,1))						AS [infected_age_40_49_per_100k]
        ,CAST(ROUND(ISNULL([50-59],0),1) AS decimal(19,1))						AS [infected_age_50_59_per_100k]
        ,CAST(ROUND(ISNULL([60-69],0),1) AS decimal(19,1))						AS [infected_age_60_69_per_100k]
        ,CAST(ROUND(ISNULL([70-79],0),1) AS decimal(19,1))						AS [infected_age_70_79_per_100k]
        ,CAST(ROUND(ISNULL([80-89],0),1) AS decimal(19,1))						AS [infected_age_80_89_per_100k]
        ,CAST(ROUND(ISNULL([90+],  0),1) AS decimal(19,1))						AS [infected_age_90_plus_per_100k]
        ,CAST(ROUND(TOTAL_CASES_7D_MOVING_AVERAGE_100K,1) AS decimal(19,1))		AS [infected_overall_per_100k]
        
        --,TOTAL_CASES
        ,[DATE_UNIX]										AS [date_unix]
        ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED]) AS [date_of_insertion_unix]

    FROM  
    (SELECT   
        PostiveOverTimeByAge.[AGEGROUP]
        ,PostiveOverTimeByAge.[DATE]
        ,PostiveOverTimeByAge.[DATE_UNIX]
        --,[CASES_7D_MOVING_AVERAGE]
        ,PostiveOverTimeByAge.[CASES_7D_MOVING_AVERAGE_100K]
        --,[CASES]
        ,PostiveOverTimeByAge.[DATE_LAST_INSERTED]
        --,SUM([CASES_7D_MOVING_AVERAGE_100K]) OVER (PARTITION BY [DATE_UNIX])		AS [TOTAL_CASES_7D_MOVING_AVERAGE_100K]
        ,TotalCasesOverTime.TOTAL_CASES_7D_MOVING_AVERAGE_100K
    FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME] PostiveOverTimeByAge
    LEFT JOIN
        TotalCasesOverTime ON
        TotalCasesOverTime.[DATE] = PostiveOverTimeByAge.[DATE]
    where [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME])) AS SourceTable  
    PIVOT  
    (  
    SUM([CASES_7D_MOVING_AVERAGE_100K])  
    FOR [AGEGROUP] IN (
        [0-9]
        ,[10-19]
        ,[20-29]
        ,[30-39]
        ,[40-49]
        ,[50-59]
        ,[60-69]
        ,[70-79]
        ,[80-89]
        ,[90+]
        ) 
    ) AS PivotTable; 
