﻿CREATE TABLE [VWSDEST].[RESTRICTIONS_NATIONAL] (
    [ID]                 INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_RESTRICTIONS_NATIONAL]) NOT NULL,
    [RESTRICTION_ID]     VARCHAR (100) NULL,
    [TARGET_REGION]      VARCHAR (100) NULL,
    [ESCALATION_LEVEL]   INT           NULL,
    [CATEGORY_ID]        VARCHAR (100) NULL,
    [RESTRICTION_ORDER]  INT           NULL,
    [VALID_FROM]         DATETIME      NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_RESTRICTIONS_NATIONAL_DEST]
    ON [VWSDEST].[RESTRICTIONS_NATIONAL]([DATE_LAST_INSERTED] ASC);

