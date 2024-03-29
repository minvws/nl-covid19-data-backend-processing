﻿CREATE TABLE [VWSSTAGE].[RIVM_VACCINATION_CAMPAIGNS_MASTER_DATA] (
    [ID]                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    [CAMPAIGN_LABEL_NL]  VARCHAR (255) NULL,
    [CAMPAIGN_LABEL_EN]  VARCHAR (255) NULL,
    [CAMPAIGN_CODE]      VARCHAR (255) NULL,
    [ORDER]              VARCHAR (100) NULL
);

