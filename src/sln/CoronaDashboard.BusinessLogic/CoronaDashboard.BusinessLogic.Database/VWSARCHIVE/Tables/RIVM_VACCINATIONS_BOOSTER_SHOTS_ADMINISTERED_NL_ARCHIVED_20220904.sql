﻿CREATE TABLE [VWSARCHIVE].[RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL_ARCHIVED_20220904] (
    [ID]                                    INT      DEFAULT (NEXT VALUE FOR [DBO].[SEQ_VWSARCHIVE_RIVM_VACCINATIONS_BOOSTER_SHOTS_ADMINISTERED_NL_ARCHIVED_20220904]) NOT NULL,
    [DATE_LAST_INSERTED]                    DATETIME DEFAULT (getdate()) NOT NULL,
    [VERSION]                               INT      NULL,
    [DATE_OF_REPORT]                        DATETIME NULL,
    [DATE_OF_STATISTICS]                    DATETIME NULL,
    [GGD_ADMINISTERED_BOOSTER_SHOTS]        INT      NULL,
    [GGD_CUMSUM_ADMINISTERED_BOOSTER_SHOTS] INT      NULL,
    [GGD_ADMINISTERED_BOOSTER_SHOTS_7DAYS]  INT      NULL,
    [OTHERS_ESTIMATED_BOOSTER_SHOTS]        INT      NULL,
    [OTHERS_CUMSUM_ESTIMATED_BOOSTER_SHOTS] INT      NULL,
    [OTHERS_ESTIMATED_BOOSTER_SHOTS_7DAYS]  INT      NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);

