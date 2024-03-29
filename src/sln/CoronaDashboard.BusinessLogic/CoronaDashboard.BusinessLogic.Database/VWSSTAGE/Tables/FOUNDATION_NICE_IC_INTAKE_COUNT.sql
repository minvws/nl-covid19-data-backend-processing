﻿CREATE TABLE [VWSSTAGE].[FOUNDATION_NICE_IC_INTAKE_COUNT] (
    [ID]                 INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_FOUNDATION_NICE_IC_INTAKE_COUNT]) NOT NULL,
    [DATE]               VARCHAR (100) NULL,
    [VALUE]              VARCHAR (100) NULL,
    [BATCH_ID]           INT           NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_STAGE_FOUNDATION_NICE_IC_INTAKE_COUNT]
    ON [VWSSTAGE].[FOUNDATION_NICE_IC_INTAKE_COUNT]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE], [VALUE]);


GO
CREATE NONCLUSTERED INDEX [IX_FOUNDATION_NICE_IC_INTAKE_COUNT]
    ON [VWSSTAGE].[FOUNDATION_NICE_IC_INTAKE_COUNT]([DATE_LAST_INSERTED] ASC);

