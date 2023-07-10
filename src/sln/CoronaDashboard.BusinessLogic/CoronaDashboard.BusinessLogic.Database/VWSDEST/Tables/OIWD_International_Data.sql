CREATE TABLE [VWSDEST].[OIWD_International_Data] (
    [ID]                                    INT             DEFAULT (NEXT VALUE FOR [DBO].[SEQ_VWSDEST_CBS_DECEASED_VR]) NOT NULL,
    [iso_code]                              VARCHAR (50)    NULL,
    [continent]                             VARCHAR (50)    NULL,
    [location]                              VARCHAR (50)    NULL,
    [date]                                  DATE            NULL,
    [total_cases]                           DECIMAL (19)    NULL,
    [new_cases]                             DECIMAL (25, 1) NULL,
    [new_cases_smoothed]                    DECIMAL (19, 3) NULL,
    [total_deaths]                          DECIMAL (19)    NULL,
    [new_deaths]                            DECIMAL (19)    NULL,
    [new_deaths_smoothed]                   DECIMAL (19, 3) NULL,
    [total_cases_per_million]               DECIMAL (19, 3) NULL,
    [new_cases_per_million]                 DECIMAL (19, 3) NULL,
    [new_cases_smoothed_per_million]        DECIMAL (19, 3) NULL,
    [total_deaths_per_million]              DECIMAL (19, 3) NULL,
    [new_deaths_per_million]                DECIMAL (19, 3) NULL,
    [new_deaths_smoothed_per_million]       DECIMAL (19, 3) NULL,
    [reproduction_rate]                     DECIMAL (19, 3) NULL,
    [icu_patients]                          DECIMAL (19)    NULL,
    [icu_patients_per_million]              DECIMAL (19, 3) NULL,
    [hosp_patients]                         DECIMAL (19)    NULL,
    [hosp_patients_per_million]             DECIMAL (19, 3) NULL,
    [weekly_icu_admissions]                 DECIMAL (19, 3) NULL,
    [weekly_icu_admissions_per_million]     DECIMAL (19, 3) NULL,
    [weekly_hosp_admissions]                DECIMAL (19, 3) NULL,
    [weekly_hosp_admissions_per_million]    DECIMAL (19, 3) NULL,
    [new_tests]                             DECIMAL (19)    NULL,
    [total_tests]                           DECIMAL (19)    NULL,
    [total_tests_per_thousand]              DECIMAL (19, 3) NULL,
    [new_tests_per_thousand]                DECIMAL (19, 3) NULL,
    [new_tests_smoothed]                    DECIMAL (19)    NULL,
    [new_tests_smoothed_per_thousand]       DECIMAL (19, 3) NULL,
    [positive_rate]                         DECIMAL (19, 3) NULL,
    [tests_per_case]                        DECIMAL (19, 3) NULL,
    [tests_units]                           VARCHAR (50)    NULL,
    [total_vaccinations]                    DECIMAL (19)    NULL,
    [people_vaccinated]                     DECIMAL (19)    NULL,
    [people_fully_vaccinated]               DECIMAL (19)    NULL,
    [new_vaccinations]                      DECIMAL (19)    NULL,
    [new_vaccinations_smoothed]             DECIMAL (19)    NULL,
    [total_vaccinations_per_hundred]        DECIMAL (19, 3) NULL,
    [people_vaccinated_per_hundred]         DECIMAL (19, 3) NULL,
    [people_fully_vaccinated_per_hundred]   DECIMAL (19, 3) NULL,
    [new_vaccinations_smoothed_per_million] DECIMAL (19)    NULL,
    [stringency_index]                      DECIMAL (19, 3) NULL,
    [population]                            DECIMAL (19)    NULL,
    [population_density]                    DECIMAL (19, 3) NULL,
    [median_age]                            DECIMAL (19, 3) NULL,
    [aged_65_older]                         DECIMAL (19, 3) NULL,
    [aged_70_older]                         DECIMAL (19, 3) NULL,
    [gdp_per_capita]                        DECIMAL (19, 3) NULL,
    [extreme_poverty]                       DECIMAL (19, 3) NULL,
    [cardiovasc_death_rate]                 DECIMAL (19, 3) NULL,
    [diabetes_prevalence]                   DECIMAL (19, 3) NULL,
    [female_smokers]                        DECIMAL (19, 3) NULL,
    [male_smokers]                          DECIMAL (19, 3) NULL,
    [handwashing_facilities]                DECIMAL (19, 3) NULL,
    [hospital_beds_per_thousand]            DECIMAL (19, 3) NULL,
    [life_expectancy]                       DECIMAL (19, 3) NULL,
    [human_development_index]               DECIMAL (19, 3) NULL,
    [DATE_LAST_INSERTED]                    DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VWS_VWSDEST_OIWD_International_Data2]
    ON [VWSDEST].[OIWD_International_Data]([DATE_LAST_INSERTED] ASC, [iso_code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_VWS_VWSDEST_OIWD_International_Data]
    ON [VWSDEST].[OIWD_International_Data]([DATE_LAST_INSERTED] ASC)
    INCLUDE([iso_code], [date]);

