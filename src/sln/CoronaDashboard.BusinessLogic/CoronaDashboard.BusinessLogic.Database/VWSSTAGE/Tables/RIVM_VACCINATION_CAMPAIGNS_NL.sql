﻿CREATE TABLE [VWSSTAGE].[RIVM_VACCINATION_CAMPAIGNS_NL] (
    [ID]                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    [DATE_OF_REPORT]     VARCHAR (50)  NULL,
    [DATE_OF_STATISTICS] VARCHAR (50)  NULL,
    [CAMPAIGN]           VARCHAR (255) NULL,
    [TOTAL_VACCINATED]   VARCHAR (255) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

