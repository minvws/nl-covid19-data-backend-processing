﻿CREATE TABLE [VWSINTER].[RIVM_NURSING_HOMES_DECEASED_PER_REGION] (
    [ID]                   INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_NURSING_HOMES_DECEASED_PER_REGION]) NOT NULL,
    [VEILIGHEIDSREGIOCODE] VARCHAR (100) NULL,
    [VEILIGHEIDSREGIONAAM] VARCHAR (100) NULL,
    [DATUM_VAN_OVERLIJDEN] DATETIME      NULL,
    [AANTAL]               INT           NULL,
    [DATE_LAST_INSERTED]   DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

