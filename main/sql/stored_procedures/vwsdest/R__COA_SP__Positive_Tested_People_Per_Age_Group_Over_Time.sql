-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Stored procedure for creating infected people per age group
CREATE OR ALTER PROCEDURE DBO.SP_POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME
AS
BEGIN
-- Move data from intermediate table to destination table.
	WITH 
	-- All date * ages in scope
	AllDatesAges ([DATE_STATISTICS], AGEGROUP)
	AS (

		SELECT [DATE_STATISTICS], AGEGROUP 
		FROM (
			SELECT DISTINCT AGEGROUP 
			FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL
			WHERE AGEGROUP NOT IN ('<50', 'Unknown') -- ignore cases "Unknown" and "<50"
			AND DATE_LAST_INSERTED = (
				SELECT MAX(DATE_LAST_INSERTED) 
				FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL)
			) Ages
		CROSS JOIN (
			SELECT DISTINCT [DATE_STATISTICS] 
			FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL
			WHERE 
				DATE_LAST_INSERTED = (
					SELECT MAX(DATE_LAST_INSERTED) 
					FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL) AND
				DATE_STATISTICS >= CAST('2020-06-01' as date) -- Start with 1st of June 2020
				) Dates
	),	
	PositivesGroupedByAge (AGEGROUP, DATE_STATISTICS, [CASES]) 
	AS (
		SELECT
			AllDatesAges.AGEGROUP, 
			AllDatesAges.[DATE_STATISTICS],
			ISNULL(COUNT(CaseNational.[DATE_STATISTICS]),0)					AS [CASES]
		FROM 
			AllDatesAges
		LEFT JOIN
			VWSINTER.RIVM_COVID_19_CASE_NATIONAL CaseNational ON
			CaseNational.DATE_LAST_INSERTED = (
				SELECT MAX(DATE_LAST_INSERTED) 
				FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL) AND
			AllDatesAges.[DATE_STATISTICS] = CaseNational.[DATE_STATISTICS] AND
			AllDatesAges.AGEGROUP = CaseNational.AGEGROUP
		GROUP BY
			AllDatesAges.AGEGROUP,
			AllDatesAges.DATE_STATISTICS
	)
	INSERT INTO [VWSDEST].[POSITIVE_TESTED_PEOPLE_PER_AGE_GROUP_OVER_TIME]
		(
		[AGEGROUP],
		[DATE],
		[DATE_UNIX],
		[CASES_7D_MOVING_AVERAGE],
		[CASES_7D_MOVING_AVERAGE_100K],
		[CASES])
	SELECT
		PositivesGroupedByAge.AGEGROUP													AS [AGEGROUP], 
		PositivesGroupedByAge.DATE_STATISTICS											AS [DATE], 
		dbo.CONVERT_DATETIME_TO_UNIX(
			PositivesGroupedByAge.DATE_STATISTICS)										AS [DATE_UNIX],

		AVG(
			CAST(PositivesGroupedByAge.[CASES] as decimal)
			) OVER (
				PARTITION BY 
					PositivesGroupedByAge.AGEGROUP 
				ORDER BY 
					PositivesGroupedByAge.DATE_STATISTICS ASC 
				ROWS 6 PRECEDING)														AS [CASES_7D_MOVING_AVERAGE],
		(100000.0 / CONVERT(decimal, AgeGroupDistribution.[INHABITANTS])) *
			AVG(
				CAST(PositivesGroupedByAge.[CASES] as decimal)
				) OVER (
					PARTITION BY 
						PositivesGroupedByAge.AGEGROUP 
					ORDER BY 
						PositivesGroupedByAge.DATE_STATISTICS ASC 
					ROWS 6 PRECEDING)
																						AS [CASES_7D_MOVING_AVERAGE_100K],
		[CASES]
	FROM
		PositivesGroupedByAge
	LEFT JOIN
		[VWSSTATIC].[CBS_AGEGROUP_DISTRIBUTION] AgeGroupDistribution ON
		AgeGroupDistribution.AGEGROUP = PositivesGroupedByAge.AGEGROUP AND
		AgeGroupDistribution.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSSTATIC].[CBS_AGEGROUP_DISTRIBUTION])
	ORDER BY
		PositivesGroupedByAge.AGEGROUP, DATE_STATISTICS

END