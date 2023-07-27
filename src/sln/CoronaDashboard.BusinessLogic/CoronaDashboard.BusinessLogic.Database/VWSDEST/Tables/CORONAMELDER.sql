﻿CREATE TABLE [VWSDEST].[CORONAMELDER] (
    [ID]                 INT      DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_CORONAMELDER]) NOT NULL,
    [DOWNLOADED_TOTAL]   INT      NULL,
    [WARNED_DAILY]       INT      NULL,
    [DATE_OF_REPORT]     DATETIME NULL,
    [DATE_LAST_INSERTED] DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_CORONAMELDER]
    ON [VWSDEST].[CORONAMELDER]([DATE_OF_REPORT] ASC, [DATE_LAST_INSERTED] ASC);

