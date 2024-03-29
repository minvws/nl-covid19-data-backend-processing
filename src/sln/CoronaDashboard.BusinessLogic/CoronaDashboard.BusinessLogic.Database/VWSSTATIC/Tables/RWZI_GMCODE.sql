﻿CREATE TABLE [VWSSTATIC].[RWZI_GMCODE] (
    [RWZI_CODE]          VARCHAR (100) NOT NULL,
    [GM_CODE]            VARCHAR (100) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_STATIC_RWZI_GMCODE]
    ON [VWSSTATIC].[RWZI_GMCODE]([DATE_LAST_INSERTED] ASC)
    INCLUDE([RWZI_CODE], [GM_CODE]);

