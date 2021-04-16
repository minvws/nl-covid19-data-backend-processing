-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_OIWD_International_Data]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_OIWD_International_Data
  START WITH 1
  INCREMENT BY 1;
GO


CREATE TABLE VWSDEST.OIWD_International_Data(
  [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [DBO].[SEQ_VWSDEST_CBS_DECEASED_VR]),
  [iso_code] [varchar](50) NULL,
	[continent] [varchar](50) NULL,
	[location] [varchar](50) NULL,
	[date] [date] NULL,
	[total_cases] [decimal](19, 0) NULL,
	[new_cases] [decimal](25, 1) NULL,
	[new_cases_smoothed] [decimal](19, 3) NULL,
	[total_deaths] [decimal](19, 0) NULL,
	[new_deaths] [decimal](19, 0) NULL,
	[new_deaths_smoothed] [decimal](19, 3) NULL,
	[total_cases_per_million] [decimal](19, 3) NULL,
	[new_cases_per_million] [decimal](19, 3) NULL,
	[new_cases_smoothed_per_million] [decimal](19, 3) NULL,
	[total_deaths_per_million] [decimal](19, 3) NULL,
	[new_deaths_per_million] [decimal](19, 3) NULL,
	[new_deaths_smoothed_per_million] [decimal](19, 3) NULL,
	[reproduction_rate] [decimal](19, 3) NULL,
	[icu_patients] [decimal](19, 0) NULL,
	[icu_patients_per_million] [decimal](19, 3) NULL,
	[hosp_patients] [decimal](19, 0) NULL,
	[hosp_patients_per_million] [decimal](19, 3) NULL,
	[weekly_icu_admissions] [decimal](19, 3) NULL,
	[weekly_icu_admissions_per_million] [decimal](19, 3) NULL,
	[weekly_hosp_admissions] [decimal](19, 3) NULL,
	[weekly_hosp_admissions_per_million] [decimal](19, 3) NULL,
	[new_tests] [decimal](19, 0) NULL,
	[total_tests] [decimal](19, 0) NULL,
	[total_tests_per_thousand] [decimal](19, 3) NULL,
	[new_tests_per_thousand] [decimal](19, 3) NULL,
	[new_tests_smoothed] [decimal](19, 0) NULL,
	[new_tests_smoothed_per_thousand] [decimal](19, 3) NULL,
	[positive_rate] [decimal](19, 3) NULL,
	[tests_per_case] [decimal](19, 3) NULL,
	[tests_units] [varchar](50) NULL,
	[total_vaccinations] [decimal](19, 0) NULL,
	[people_vaccinated] [decimal](19, 0) NULL,
	[people_fully_vaccinated] [decimal](19, 0) NULL,
	[new_vaccinations] [decimal](19, 0) NULL,
	[new_vaccinations_smoothed] [decimal](19, 0) NULL,
	[total_vaccinations_per_hundred] [decimal](19, 3) NULL,
	[people_vaccinated_per_hundred] [decimal](19, 3) NULL,
	[people_fully_vaccinated_per_hundred] [decimal](19, 3) NULL,
	[new_vaccinations_smoothed_per_million] [decimal](19, 0) NULL,
	[stringency_index] [decimal](19, 3) NULL,
	[population] [decimal](19, 0) NULL,
	[population_density] [decimal](19, 3) NULL,
	[median_age] [decimal](19, 3) NULL,
	[aged_65_older] [decimal](19, 3) NULL,
	[aged_70_older] [decimal](19, 3) NULL,
	[gdp_per_capita] [decimal](19, 3) NULL,
	[extreme_poverty] [decimal](19, 3) NULL,
	[cardiovasc_death_rate] [decimal](19, 3) NULL,
	[diabetes_prevalence] [decimal](19, 3) NULL,
	[female_smokers] [decimal](19, 3) NULL,
	[male_smokers] [decimal](19, 3) NULL,
	[handwashing_facilities] [decimal](19, 3) NULL,
	[hospital_beds_per_thousand] [decimal](19, 3) NULL,
	[life_expectancy] [decimal](19, 3) NULL,
	[human_development_index] [decimal](19, 3) NULL,  
  [DATE_LAST_INSERTED] DATETIME DEFAULT GETDATE()
);

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME='IX_VWS_VWSDEST_OIWD_International_Data')
    CREATE NONCLUSTERED INDEX IX_VWS_VWSDEST_OIWD_International_Data
    ON VWSDEST.OIWD_International_Data(DATE_LAST_INSERTED)
    INCLUDE (ISO_CODE, [DATE]);
GO

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME='IX_VWS_VWSDEST_OIWD_International_Data2')
    CREATE NONCLUSTERED INDEX IX_VWS_VWSDEST_OIWD_International_Data2
    ON VWSDEST.OIWD_International_Data(DATE_LAST_INSERTED, ISO_CODE);


GO