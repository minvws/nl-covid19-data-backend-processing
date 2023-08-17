﻿CREATE TABLE [VWSDEST].[RIVM_INFECTIE_RADAR_TREND_PER_LEEFTIJD] (
    [ID]                     BIGINT        IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED]     DATETIME      DEFAULT (getdate()) NULL,
    [VERSION]                INT           NULL,
    [DATE_OF_REPORT]         DATETIME2 (7) NULL,
    [DATE_OF_STATISTICS]     DATETIME2 (7) NULL,
    [PERC_COVID_SYMPTOMS]    FLOAT (53)    NULL,
    [MA_PERC_COVID_SYMPTOMS] FLOAT (53)    NULL,
    [AGE_GROUPS]             VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_DLI_RIVM_INFECTIE_RADAR_TREND_PER_LEEFTIJD]
    ON [VWSDEST].[RIVM_INFECTIE_RADAR_TREND_PER_LEEFTIJD]([DATE_LAST_INSERTED] ASC);

