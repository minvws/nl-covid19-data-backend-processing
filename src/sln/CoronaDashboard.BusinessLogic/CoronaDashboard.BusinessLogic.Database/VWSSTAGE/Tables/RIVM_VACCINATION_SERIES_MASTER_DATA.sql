﻿CREATE TABLE [VWSSTAGE].[RIVM_VACCINATION_SERIES_MASTER_DATA] (
    [ID]                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [VERSION]            VARCHAR (100) NULL,
    [VACCINATION_KEY]    VARCHAR (100) NULL,
    [SERIES_START_DATE]  VARCHAR (100) NULL,
    [SERIES_END_DATE]    VARCHAR (100) NULL,
    [LABEL_NL]           VARCHAR (100) NULL,
    [LABEL_EN]           VARCHAR (100) NULL,
    [SORT_ORDER]         VARCHAR (100) NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

