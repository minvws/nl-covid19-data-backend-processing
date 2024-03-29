﻿CREATE TABLE [VWSINTER].[RIVM_NURSING_HOMES_INFECTED_LOCATIONS_OLD] (
    [ID]                                   INT      DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_NURSING_HOMES_INFECTED_LOCATIONS]) NOT NULL,
    [DATUM]                                DATETIME NULL,
    [AANTAL_NIEUW_BESMETTE_VERPLEEGHUIZEN] INT      NULL,
    [AANTAL_BESMETTE_VERPLEEGHUIZEN]       INT      NULL,
    [DATE_LAST_INSERTED]                   DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_RIVM_NURSING_HOMES_INFECTED_LOCATIONS]
    ON [VWSINTER].[RIVM_NURSING_HOMES_INFECTED_LOCATIONS_OLD]([DATE_LAST_INSERTED] ASC, [DATUM] ASC);

