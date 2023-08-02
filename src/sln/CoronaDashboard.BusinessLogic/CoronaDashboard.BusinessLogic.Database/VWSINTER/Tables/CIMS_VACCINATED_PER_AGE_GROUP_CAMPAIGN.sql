CREATE TABLE [VWSINTER].[CIMS_VACCINATED_PER_AGE_GROUP_CAMPAIGN] (
    [ID]                            BIGINT          IDENTITY (1, 1) NOT NULL,
    [DATE_OF_REPORT]                DATETIME        NULL,
    [DATE_OF_STATISTICS_WEEK_START] DATETIME        NULL,
    [DATE_OF_STATISTICS_WEEK_END]   DATETIME        NULL,
    [BIRTH_COHORT]                  VARCHAR (100)   NULL,
    [AGE_GROUP]                     VARCHAR (100)   NULL,
    [POPULATION_AGE_GROUP]          BIGINT          NULL,
    [VACCINATION_CAMPAIGN]          VARCHAR (100)   NULL,
    [RECEIVED]                      BIGINT          NULL,
    [COVERAGE]                      DECIMAL (16, 2) NULL,
    [DATE_LAST_INSERTED]            DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

