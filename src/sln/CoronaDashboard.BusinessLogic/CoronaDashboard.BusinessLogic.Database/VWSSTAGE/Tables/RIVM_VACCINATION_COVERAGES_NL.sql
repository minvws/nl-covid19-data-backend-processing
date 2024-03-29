﻿CREATE TABLE [VWSSTAGE].[RIVM_VACCINATION_COVERAGES_NL] (
    [ID]                  BIGINT        IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED]  DATETIME      DEFAULT (getdate()) NULL,
    [DATE_OF_REPORT]      VARCHAR (50)  NULL,
    [DATE_OF_STATISTICS]  VARCHAR (50)  NULL,
    [BIRTH_YEAR]          VARCHAR (50)  NULL,
    [VACCINATION_SERIES]  VARCHAR (255) NULL,
    [PERCENTAGE_COVERAGE] VARCHAR (255) NULL,
    [VERSION]             VARCHAR (50)  NULL,
    [AGEGROUP]            VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

