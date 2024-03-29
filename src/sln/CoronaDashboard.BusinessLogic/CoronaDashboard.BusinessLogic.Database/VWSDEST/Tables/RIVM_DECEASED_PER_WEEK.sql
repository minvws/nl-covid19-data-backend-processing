﻿CREATE TABLE [VWSDEST].[RIVM_DECEASED_PER_WEEK] (
    [ID]                 INT         DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_RIVM_DECEASED_PER_WEEK]) NOT NULL,
    [WEEK_START]         DATETIME    NULL,
    [WEEK_END]           DATETIME    NULL,
    [WEEK_START_UNIX]    BIGINT      NULL,
    [WEEK_END_UNIX]      BIGINT      NULL,
    [DECEASED_ACTUAL]    INT         NULL,
    [VRCODE]             VARCHAR (5) NULL,
    [DATE_LAST_INSERTED] DATETIME    DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_SEWER_MEASUREMENTS_PER_MUNICIPALITY_DLI_WS]
    ON [VWSDEST].[RIVM_DECEASED_PER_WEEK]([DATE_LAST_INSERTED] ASC, [WEEK_START] ASC)
    INCLUDE([WEEK_START_UNIX], [DECEASED_ACTUAL], [VRCODE]);

