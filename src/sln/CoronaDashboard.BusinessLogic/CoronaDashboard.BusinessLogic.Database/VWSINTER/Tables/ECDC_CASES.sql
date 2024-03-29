﻿CREATE TABLE [VWSINTER].[ECDC_CASES] (
    [ID]                 INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_ECDC_CASES]) NOT NULL,
    [COUNTRY]            VARCHAR (100) NULL,
    [COUNTRY_CODE]       VARCHAR (100) NULL,
    [CONTINENT]          VARCHAR (100) NULL,
    [POPULATION]         BIGINT        NULL,
    [INDICATOR]          VARCHAR (100) NULL,
    [WEEKLY_COUNT]       BIGINT        NULL,
    [YEAR_WEEK]          VARCHAR (100) NULL,
    [WEEK_START]         DATE          NULL,
    [WEEK_END]           DATE          NULL,
    [RATE_14_DAY]        FLOAT (53)    NULL,
    [CUMULATIVE_COUNT]   BIGINT        NULL,
    [SOURCE]             VARCHAR (100) NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_ECDC_CASES]
    ON [VWSINTER].[ECDC_CASES]([DATE_LAST_INSERTED] ASC)
    INCLUDE([COUNTRY], [COUNTRY_CODE], [CONTINENT], [POPULATION], [INDICATOR], [WEEKLY_COUNT], [YEAR_WEEK], [WEEK_START], [WEEK_END], [RATE_14_DAY], [CUMULATIVE_COUNT], [SOURCE]);

