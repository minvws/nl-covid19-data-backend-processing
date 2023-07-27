﻿CREATE TABLE [VWSDEST].[REPRODUCTION_NUMBER] (
    [ID]                      INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_REPRODUCTION_NUMBER]) NOT NULL,
    [DATE_OF_REPORT]          DATETIME        NULL,
    [DATE_OF_REPORT_UNIX]     BIGINT          NULL,
    [REPRODUCTION_INDEX_LOW]  DECIMAL (16, 4) NULL,
    [REPRODUCTION_INDEX_AVG]  DECIMAL (16, 4) NULL,
    [REPRODUCTION_INDEX_HIGH] DECIMAL (16, 4) NULL,
    [DATE_LAST_INSERTED]      DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_REPRODUCTION_NUMBER_DOR]
    ON [VWSDEST].[REPRODUCTION_NUMBER]([DATE_OF_REPORT] ASC)
    INCLUDE([DATE_OF_REPORT_UNIX], [REPRODUCTION_INDEX_LOW], [REPRODUCTION_INDEX_AVG], [REPRODUCTION_INDEX_HIGH], [DATE_LAST_INSERTED]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_REPRODUCTION_NUMBER_DLI_DOR]
    ON [VWSDEST].[REPRODUCTION_NUMBER]([DATE_LAST_INSERTED] ASC, [DATE_OF_REPORT] ASC)
    INCLUDE([DATE_OF_REPORT_UNIX], [REPRODUCTION_INDEX_LOW], [REPRODUCTION_INDEX_AVG], [REPRODUCTION_INDEX_HIGH]);

