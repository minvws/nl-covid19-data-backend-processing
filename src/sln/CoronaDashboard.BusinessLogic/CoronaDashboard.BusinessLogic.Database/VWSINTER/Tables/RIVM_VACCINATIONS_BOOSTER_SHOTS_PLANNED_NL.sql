﻿CREATE TABLE [VWSINTER].[RIVM_VACCINATIONS_BOOSTER_SHOTS_PLANNED_NL] (
    [ID]                    INT           DEFAULT (NEXT VALUE FOR [DBO].[SEQ_VWSINTER_RIVM_VACCINATIONS_BOOSTER_SHOTS_PLANNED_NL]) NOT NULL,
    [DATE_LAST_INSERTED]    DATETIME      DEFAULT (getdate()) NOT NULL,
    [VERSION]               INT           NULL,
    [DATE_OF_REPORT]        DATETIME      NULL,
    [DATE_OF_STATISTICS]    DATETIME      NULL,
    [PLANNED_DATE]          DATETIME      NULL,
    [TYPE_PLANNED_DATE]     VARCHAR (256) NULL,
    [PLANNED_BOOSTER_SHOTS] INT           NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_RIVM_VACCINATIONS_BOOSTER_SHOTS_PLANNED_NL]
    ON [VWSINTER].[RIVM_VACCINATIONS_BOOSTER_SHOTS_PLANNED_NL]([DATE_LAST_INSERTED] ASC);

