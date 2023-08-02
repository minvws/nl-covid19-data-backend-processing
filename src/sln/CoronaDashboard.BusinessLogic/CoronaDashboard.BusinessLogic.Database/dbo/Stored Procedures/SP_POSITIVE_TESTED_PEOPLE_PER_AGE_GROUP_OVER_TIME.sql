-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Stored procedure for creating infected people per age group
CREATE   PROCEDURE DBO.SP_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME
AS
BEGIN
-- Move data from intermediate table to destination table.

-- Get latest values from inter table and neglect records with unusable or irreliable data
WITH RECENT_CTE AS (
    SELECT 
        [AGEGROUP]
       ,[DATE_STATISTICS]
    FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL)
      AND AGEGROUP NOT IN ('<50', 'Unknown') -- ignore cases "Unknown" and "<50"
),
AGEGROUP_POPULATION AS (
SELECT 
	 AGEGROUP
	,DATUM_PEILING
	,POPULATIE
FROM VWSSTATIC.CBS_POPULATION_AGEGROUP_10
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.CBS_POPULATION_AGEGROUP_10)
UNION ALL 
SELECT
	   'Total' AS [AGEGROUP]
      ,[DATUM_PEILING]
      ,[POPULATIE]
FROM [VWSSTATIC].[CBS_POPULATION_NL]
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.CBS_POPULATION_NL)
)
,
--Determine ranges in which population numbers should be used
AGEGROUP_POPULATION_DATERANGE AS (
SELECT 
	 AGEGROUP
	,DATUM_PEILING AS DATE_FROM
    -- 2100-01-01 is used as convention for the most recent versions as no end date is known yet.
    ,ISNULL(LEAD(DATUM_PEILING,1) OVER (PARTITION BY AGEGROUP ORDER BY [DATUM_PEILING] ASC),CAST('2100-01-01' AS DATE)) AS DATE_TO
	,POPULATIE AS [POPULATION]
FROM AGEGROUP_POPULATION
),

-- All date * ages in scope
AllDatesAges ([DATE_STATISTICS], AGEGROUP)
	AS (

		SELECT 
             [DATE_STATISTICS]
            ,AGEGROUP 
		FROM    
                (SELECT DISTINCT AGEGROUP FROM RECENT_CTE) Ages
		CROSS JOIN 
                (SELECT DISTINCT [DATE_STATISTICS] FROM RECENT_CTE ) Dates
	),	
PositivesGroupedByAge (AGEGROUP, DATE_STATISTICS, [CASES]) 
	AS (
		SELECT
			AllDatesAges.AGEGROUP, 
			AllDatesAges.[DATE_STATISTICS],
			ISNULL(COUNT(RECENT_CTE.[DATE_STATISTICS]),0)					AS [CASES]
		FROM 
			AllDatesAges
		LEFT JOIN
			RECENT_CTE ON
			AllDatesAges.[DATE_STATISTICS] = RECENT_CTE.[DATE_STATISTICS] AND
			AllDatesAges.AGEGROUP = RECENT_CTE.AGEGROUP
		GROUP BY
			AllDatesAges.AGEGROUP,
			AllDatesAges.DATE_STATISTICS
	)
,
PositivesGroupedByAgeWithTotal 
	AS (
        SELECT
            AGEGROUP,
            [DATE_STATISTICS],
            [CASES]
        FROM PositivesGroupedByAge
        UNION ALL
        SELECT
            'Total'             AS AGEGROUP,
            [DATE_STATISTICS],
            SUM([CASES])        AS [CASES] 
        FROM PositivesGroupedByAge
        GROUP BY [DATE_STATISTICS]
	)
,
--Add matching population numbers and calculate 7 day average
PositivesCalculated
    AS (
    SELECT
        T0.AGEGROUP															AS [AGEGROUP],
        T0.DATE_STATISTICS													AS [DATE],
        T0.[CASES],
        T1.POPULATION,
        LAG([DATE_STATISTICS],6) 
            OVER (PARTITION BY T0.AGEGROUP ORDER BY T0.DATE_STATISTICS)   	AS [DATE_7D_START],
        LAG(T1.[POPULATION],6) 
            OVER (PARTITION BY T0.AGEGROUP ORDER BY T0.DATE_STATISTICS)   	AS [POPULATION_7D_START],
        AVG(
            CAST(T0.[CASES] as decimal)
            ) OVER (
                PARTITION BY 
                    T0.AGEGROUP 
                ORDER BY 
                    T0.DATE_STATISTICS ASC 
                ROWS 6 PRECEDING)											AS [CASES_7D_MOVING_AVERAGE]
    FROM PositivesGroupedByAgeWithTotal AS T0
    LEFT JOIN AGEGROUP_POPULATION_DATERANGE T1 
        ON  T0.AGEGROUP = T1. AGEGROUP 
        AND (T0.DATE_STATISTICS >= T1.DATE_FROM AND T0.DATE_STATISTICS < T1.DATE_TO)
)
INSERT INTO [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME]
	(
	[AGEGROUP],
	[DATE],
	[DATE_UNIX],
	[CASES_7D_MOVING_AVERAGE],
	[CASES_7D_MOVING_AVERAGE_100K],
	[CASES]
	)
SELECT 
    [AGEGROUP], 
    [DATE], 
    dbo.CONVERT_DATETIME_TO_UNIX([DATE])    	    AS [DATE_UNIX], 
    [CASES_7D_MOVING_AVERAGE],
    --For measures that cover 7 days, the population of the first day should be used
    (100000.0 / CONVERT(decimal, [POPULATION_7D_START])) * [CASES_7D_MOVING_AVERAGE] AS [CASES_7D_MOVING_AVERAGE_100K],
    [CASES]
FROM PositivesCalculated
      WHERE [DATE] >= CAST('2020-06-01' as date) -- Display dates from 1st of June 2020
	  ORDER BY AGEGROUP, [DATE]
END