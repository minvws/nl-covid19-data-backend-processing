﻿CREATE TABLE [VWSDEST].[RIVM_INFECTIE_RADAR_POSITIVE_TESTS_WEEKLY_NL] (
    [ID]                              INT             IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED]              DATETIME        DEFAULT (getdate()) NOT NULL,
    [VERSION]                         INT             NULL,
    [DATE_OF_REPORT]                  DATETIME        NULL,
    [DATE_OF_STATISTICS]              DATETIME        NULL,
    [N_PARTICIPANTS_TOTAL]            INT             NULL,
    [N_PARTICIPANTS_TOTAL_UNFILTERED] INT             NULL,
    [N_WITH_SYMPTOMS]                 INT             NULL,
    [N_WITH_SHARED_COVID_TEST_RESULT] INT             NULL,
    [N_TESTED_POSITIVE]               INT             NULL,
    [PERC_COVID_TEST_POSITIVE]        NUMERIC (10, 2) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_RIVM_INFECTIE_RADAR_POSITIVE_TESTS_WEEKLY_NL]
    ON [VWSDEST].[RIVM_INFECTIE_RADAR_POSITIVE_TESTS_WEEKLY_NL]([DATE_LAST_INSERTED] ASC);

