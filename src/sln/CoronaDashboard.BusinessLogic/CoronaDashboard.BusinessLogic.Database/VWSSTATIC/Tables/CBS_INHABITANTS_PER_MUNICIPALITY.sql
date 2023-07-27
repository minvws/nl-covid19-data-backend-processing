﻿CREATE TABLE [VWSSTATIC].[CBS_INHABITANTS_PER_MUNICIPALITY] (
    [ID]                 INT          DEFAULT (NEXT VALUE FOR [dbo].[SEQ_CBS_INHABITANTS_PER_MUNICIPALITY]) NOT NULL,
    [VRCODE]             VARCHAR (5)  NULL,
    [GMCODE]             VARCHAR (10) NULL,
    [INHABITANTS]        BIGINT       NULL,
    [DATE_LAST_INSERTED] DATETIME     DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VWS_VWSSTATIC_CBS_INHABITANTS_PER_MUNICIPALITY]
    ON [VWSSTATIC].[CBS_INHABITANTS_PER_MUNICIPALITY]([DATE_LAST_INSERTED] ASC, [VRCODE] ASC, [GMCODE] ASC)
    INCLUDE([INHABITANTS]);

