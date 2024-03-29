﻿CREATE TABLE [VWSARCHIVE].[CIMS_VACCINATED_PER_AGE_GROUP_ARCHIVED_20220908] (
    [ID]                              BIGINT          IDENTITY (1, 1) NOT NULL,
    [DATE_OF_REPORT]                  DATETIME        NULL,
    [DATE_OF_STATISTICS_WEEK_START]   DATETIME        NULL,
    [DATE_OF_STATISTICS_WEEK_END]     DATETIME        NULL,
    [AGE_GROUP]                       VARCHAR (100)   NULL,
    [AGE_GROUP_POPULATION]            BIGINT          NULL,
    [AGE_GROUP_POPULATION_PERCENTAGE] DECIMAL (16, 2) NULL,
    [VACCINATION_ALL]                 BIGINT          NULL,
    [VACCINATION_COMPLETED]           BIGINT          NULL,
    [VACCINATED_PARTIALLY]            BIGINT          NULL,
    [VACCINATION_COVERAGE_ALL]        DECIMAL (16, 2) NULL,
    [VACCINATED_COVERAGE_PARTIALLY]   DECIMAL (16, 2) NULL,
    [VACCINATION_COVERAGE_COMPLETED]  DECIMAL (16, 2) NULL,
    [DATE_LAST_INSERTED]              DATETIME        DEFAULT (getdate()) NULL,
    [BIRTH_COHORT]                    VARCHAR (100)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_DLI_DOS_AG_CIMS_VACCINATED_PER_AGE_GROUP_ARCHIVED_20220908]
    ON [VWSARCHIVE].[CIMS_VACCINATED_PER_AGE_GROUP_ARCHIVED_20220908]([DATE_LAST_INSERTED] ASC, [DATE_OF_STATISTICS_WEEK_START] ASC, [DATE_OF_STATISTICS_WEEK_END] ASC, [AGE_GROUP] ASC);

