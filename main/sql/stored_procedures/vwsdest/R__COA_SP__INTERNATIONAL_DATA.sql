-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER PROCEDURE dbo.SP_OIWD_International_Data
AS
BEGIN
	INSERT INTO [VWSDEST].[OIWD_International_Data] (
		 [iso_code]
		,[continent]
		,[location]
		,[date]
		,[total_cases]
		,[new_cases]
		,[new_cases_smoothed]
		,[total_deaths]
		,[new_deaths]
		,[new_deaths_smoothed]
		,[total_cases_per_million]
		,[new_cases_per_million]
		,[new_cases_smoothed_per_million]
		,[total_deaths_per_million]
		,[new_deaths_per_million]
		,[new_deaths_smoothed_per_million]
		,[reproduction_rate]
		,[icu_patients]
		,[icu_patients_per_million]
		,[hosp_patients]
		,[hosp_patients_per_million]
		,[weekly_icu_admissions]
		,[weekly_icu_admissions_per_million]
		,[weekly_hosp_admissions]
		,[weekly_hosp_admissions_per_million]
		,[new_tests]
		,[total_tests]
		,[total_tests_per_thousand]
		,[new_tests_per_thousand]
		,[new_tests_smoothed]
		,[new_tests_smoothed_per_thousand]
		,[positive_rate]
		,[tests_per_case]
		,[tests_units]
		,[total_vaccinations]
		,[people_vaccinated]
		,[people_fully_vaccinated]
		,[new_vaccinations]
		,[new_vaccinations_smoothed]
		,[total_vaccinations_per_hundred]
		,[people_vaccinated_per_hundred]
		,[people_fully_vaccinated_per_hundred]
		,[new_vaccinations_smoothed_per_million]
		,[stringency_index]
		,[population]
		,[population_density]
		,[median_age]
		,[aged_65_older]
		,[aged_70_older]
		,[gdp_per_capita]
		,[extreme_poverty]
		,[cardiovasc_death_rate]
		,[diabetes_prevalence]
		,[female_smokers]
		,[male_smokers]
		,[handwashing_facilities]
		,[hospital_beds_per_thousand]
		,[life_expectancy]
		,[human_development_index]
	)
	SELECT 
	
		 TRY_CAST(iso_code AS varchar(50)) AS iso_code
		,TRY_CAST(continent AS varchar(50)) AS continent
		,TRY_CAST(location AS varchar(50)) AS [location]
		,TRY_CAST(date AS date) AS date
		,TRY_CAST(total_cases AS decimal(19,0)) AS total_cases
		,TRY_CAST(new_cases AS decimal(25,1)) AS new_cases
		,TRY_CAST(new_cases_smoothed AS decimal(19,3)) AS new_cases_smoothed
		,TRY_CAST(total_deaths AS decimal(19,0)) AS total_deaths
		,TRY_CAST(new_deaths AS decimal(19,0)) AS new_deaths
		,TRY_CAST(new_deaths_smoothed AS decimal(19,3)) AS new_deaths_smoothed
		,TRY_CAST(total_cases_per_million AS decimal(19,3)) AS total_cases_per_million
		,TRY_CAST(new_cases_per_million AS decimal(19,3)) AS new_cases_per_million
		,TRY_CAST(new_cases_smoothed_per_million AS decimal(19,3)) AS new_cases_smoothed_per_million
		,TRY_CAST(total_deaths_per_million AS decimal(19,3)) AS total_deaths_per_million
		,TRY_CAST(new_deaths_per_million AS decimal(19,3)) AS new_deaths_per_million
		,TRY_CAST(new_deaths_smoothed_per_million AS decimal(19,3)) AS new_deaths_smoothed_per_million
		,TRY_CAST(reproduction_rate AS decimal(19,3)) AS reproduction_rate
		,TRY_CAST(icu_patients AS decimal(19,0)) AS icu_patients
		,TRY_CAST(icu_patients_per_million AS decimal(19,3)) AS icu_patients_per_million
		,TRY_CAST(hosp_patients AS decimal(19,0)) AS hosp_patients
		,TRY_CAST(hosp_patients_per_million AS decimal(19,3)) AS hosp_patients_per_million
		,TRY_CAST(weekly_icu_admissions AS decimal(19,3)) AS weekly_icu_admissions
		,TRY_CAST(weekly_icu_admissions_per_million AS decimal(19,3)) AS weekly_icu_admissions_per_million
		,TRY_CAST(weekly_hosp_admissions AS decimal(19,3)) AS weekly_hosp_admissions
		,TRY_CAST(weekly_hosp_admissions_per_million AS decimal(19,3)) AS weekly_hosp_admissions_per_million
		,TRY_CAST(new_tests AS decimal(19,0)) AS new_tests
		,TRY_CAST(total_tests AS decimal(19,0)) AS total_tests
		,TRY_CAST(total_tests_per_thousand AS decimal(19,3)) AS total_tests_per_thousand
		,TRY_CAST(new_tests_per_thousand AS decimal(19,3)) AS new_tests_per_thousand
		,TRY_CAST(new_tests_smoothed AS decimal(19,0)) AS new_tests_smoothed
		,TRY_CAST(new_tests_smoothed_per_thousand AS decimal(19,3)) AS new_tests_smoothed_per_thousand
		,TRY_CAST(positive_rate AS decimal(19,3)) AS positive_rate
		,TRY_CAST(tests_per_case AS decimal(19,3)) AS tests_per_case
		,TRY_CAST(tests_units AS varchar(50)) AS tests_units
		,TRY_CAST(total_vaccinations AS decimal(19,0)) AS total_vaccinations
		,TRY_CAST(people_vaccinated AS decimal(19,0)) AS people_vaccinated
		,TRY_CAST(people_fully_vaccinated AS decimal(19,0)) AS people_fully_vaccinated
		,TRY_CAST(new_vaccinations AS decimal(19,0)) AS new_vaccinations
		,TRY_CAST(new_vaccinations_smoothed AS decimal(19,0)) AS new_vaccinations_smoothed
		,TRY_CAST(total_vaccinations_per_hundred AS decimal(19,3)) AS total_vaccinations_per_hundred
		,TRY_CAST(people_vaccinated_per_hundred AS decimal(19,3)) AS people_vaccinated_per_hundred
		,TRY_CAST(people_fully_vaccinated_per_hundred AS decimal(19,3)) AS people_fully_vaccinated_per_hundred
		,TRY_CAST(new_vaccinations_smoothed_per_million AS decimal(19,0)) AS new_vaccinations_smoothed_per_million
		,TRY_CAST(stringency_index AS decimal(19,3)) AS stringency_index
		,TRY_CAST(population AS decimal(19,0)) AS population
		,TRY_CAST(population_density AS decimal(19,3)) AS population_density
		,TRY_CAST(median_age AS decimal(19,3)) AS median_age
		,TRY_CAST(aged_65_older AS decimal(19,3)) AS aged_65_older
		,TRY_CAST(aged_70_older AS decimal(19,3)) AS aged_70_older
		,TRY_CAST(gdp_per_capita AS decimal(19,3)) AS gdp_per_capita
		,TRY_CAST(extreme_poverty AS decimal(19,3)) AS extreme_poverty
		,TRY_CAST(cardiovasc_death_rate AS decimal(19,3)) AS cardiovasc_death_rate
		,TRY_CAST(diabetes_prevalence AS decimal(19,3)) AS diabetes_prevalence
		,TRY_CAST(female_smokers AS decimal(19,3)) AS female_smokers
		,TRY_CAST(male_smokers AS decimal(19,3)) AS male_smokers
		,TRY_CAST(handwashing_facilities AS decimal(19,3)) AS handwashing_facilities
		,TRY_CAST(hospital_beds_per_thousand AS decimal(19,3)) AS hospital_beds_per_thousand
		,TRY_CAST(life_expectancy AS decimal(19,3)) AS life_expectancy
		,TRY_CAST(human_development_index AS decimal(19,3)) AS human_development_index

	  FROM [VWSSTAGE].[OIWD_International_Data]
	  WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSSTAGE].[OIWD_International_Data])
END