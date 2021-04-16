-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER  VIEW [VWSDEST].[V_BEHAVIOR_VACCINE_WILLINGNESS_BY_AGE_GROUP]
AS
    SELECT	  
        [Totaal]					AS [PERCENTAGE_AVERAGE]
        ,[16-24]					AS [PERCENTAGE_16_24]
        ,[25-39]					AS [PERCENTAGE_25_39]
        ,[40-54]					AS [PERCENTAGE_40_54]
        ,[55-69]					AS [PERCENTAGE_55_69]
        ,[70+]						AS [PERCENTAGE_70_PLUS]
        ,DATE_START_UNIX
        ,DATE_END_UNIX
        ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
    FROM (
        SELECT 
            DATE_LAST_INSERTED, DATE_OF_MEASUREMENT, DATE_START_UNIX, DATE_END_UNIX, AGE_GROUP, VACCINE_WILLINGNESS
        FROM
            [VWSDEST].[BEHAVIOR_VACCINE_WILLINGNESS_BY_AGE_GROUP]
        WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[BEHAVIOR_VACCINE_WILLINGNESS_BY_AGE_GROUP])
        ) SELECT_SOURCE
    PIVOT  
    (MAX([VACCINE_WILLINGNESS]) -- Only one value available
    FOR [AGE_GROUP] IN ([Totaal], [16-24], [25-39], [40-54], [55-69], [70+])  
    ) AS PivotTable; 
