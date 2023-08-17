﻿CREATE TABLE [VWSDEST].[G_NUMBER_NL] (
    [ID]                    INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_G_NUMBER_NL]) NOT NULL,
    [DATE_OF_REPORT]        DATETIME        NULL,
    [DATE_OF_REPORT_UNIX]   BIGINT          NULL,
    [DATE_OF_REPORT_START]  DATETIME        NULL,
    [POSITIVE_DAILY_7D_SUM] INT             NULL,
    [G_NUMBER]              DECIMAL (16, 1) NULL,
    [DATE_LAST_INSERTED]    DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

