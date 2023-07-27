﻿CREATE TABLE [VWSSTAGE].[RIVM_NURSING_HOMES_DECEASED_PER_REGION] (
    [ID]                   INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_RIVM_NURSING_HOMES_DECEASED_PER_REGION]) NOT NULL,
    [VEILIGHEIDSREGIOCODE] VARCHAR (100) NULL,
    [VEILIGHEIDSREGIONAAM] VARCHAR (100) NULL,
    [DATUM_VAN_OVERLIJDEN] VARCHAR (100) NULL,
    [AANTAL]               VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]   DATETIME      DEFAULT (getdate()) NULL,
    [AANTAL_CUM]           VARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_STAGE_RIVM_NURSING_HOMES_DECEASED_PER_REGION]
    ON [VWSSTAGE].[RIVM_NURSING_HOMES_DECEASED_PER_REGION]([DATE_LAST_INSERTED] ASC)
    INCLUDE([VEILIGHEIDSREGIOCODE], [VEILIGHEIDSREGIONAAM], [DATUM_VAN_OVERLIJDEN], [AANTAL]);

