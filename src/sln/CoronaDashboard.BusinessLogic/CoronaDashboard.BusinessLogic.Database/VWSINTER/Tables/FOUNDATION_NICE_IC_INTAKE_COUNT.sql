﻿CREATE TABLE [VWSINTER].[FOUNDATION_NICE_IC_INTAKE_COUNT] (
    [ID]                 INT      DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_FOUNDATION_NICE_IC_INTAKE_COUNT]) NOT NULL,
    [DATE_OF_REPORT]     DATETIME NULL,
    [VALUE]              INT      NULL,
    [DATE_LAST_INSERTED] DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_FOUNDATION_NICE_IC_INTAKE_COUNT_DLI]
    ON [VWSINTER].[FOUNDATION_NICE_IC_INTAKE_COUNT]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_OF_REPORT], [VALUE]);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_FOUNDATION_NICE_IC_INTAKE_COUNT]
    ON [VWSINTER].[FOUNDATION_NICE_IC_INTAKE_COUNT]([DATE_LAST_INSERTED] ASC);

