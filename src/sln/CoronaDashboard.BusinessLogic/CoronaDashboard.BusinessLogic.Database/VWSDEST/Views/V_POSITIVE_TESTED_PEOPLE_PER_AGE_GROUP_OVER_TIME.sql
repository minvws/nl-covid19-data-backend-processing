-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Create view for pulling infected people per age group
CREATE   VIEW VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME AS
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
        ,CAST(ROUND(ISNULL([Total],0),1) AS decimal(19,1))		                AS [infected_overall_per_100k]
        
        --,TOTAL_CASES
        ,[DATE_UNIX]										AS [date_unix]
        ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED]) AS [date_of_insertion_unix]
    FROM  
    (SELECT   
         [AGEGROUP]
        ,[CASES_7D_MOVING_AVERAGE_100K]
        ,[DATE]
        ,[DATE_UNIX]
        ,[DATE_LAST_INSERTED]
    FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME] PostiveOverTimeByAge
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME])
    ) AS SourceTable  
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
        ,[Total]
        ) 
    ) AS PivotTable;