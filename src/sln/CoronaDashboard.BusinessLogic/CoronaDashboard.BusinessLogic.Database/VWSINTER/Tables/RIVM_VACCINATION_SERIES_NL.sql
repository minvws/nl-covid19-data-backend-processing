﻿CREATE TABLE [VWSINTER].[RIVM_VACCINATION_SERIES_NL] (
    [ID]                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    [VERSION]            INT           NULL,
    [DATE_OF_REPORT]     DATETIME      NULL,
    [DATE_OF_STATISTICS] DATETIME      NULL,
    [VACCINE_SERIE]      VARCHAR (255) NULL,
    [TOTAL_VACCINATED]   INT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

