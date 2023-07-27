﻿CREATE TABLE [VWSSTAGE].[CBS_INHABITANTS_PER_AGEGROUP] (
    [STAGE_ID]              INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_CBS_INHABITANTS_PER_AGEGROUP]) NOT NULL,
    [ID]                    VARCHAR (100) NULL,
    [GESLACHT]              VARCHAR (100) NULL,
    [LEEFTIJD]              VARCHAR (100) NULL,
    [BURGERLIJKESTAAT]      VARCHAR (100) NULL,
    [REGIOS]                VARCHAR (100) NULL,
    [PERIODEN]              VARCHAR (100) NULL,
    [BEVOLKINGOP1JANUARI_1] VARCHAR (100) NULL,
    [GEMIDDELDEBEVOLKING_2] VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]    DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([STAGE_ID] ASC)
);

