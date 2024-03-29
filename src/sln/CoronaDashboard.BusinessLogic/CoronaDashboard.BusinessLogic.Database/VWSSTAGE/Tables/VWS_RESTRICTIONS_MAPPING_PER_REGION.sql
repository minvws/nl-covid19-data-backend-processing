﻿CREATE TABLE [VWSSTAGE].[VWS_RESTRICTIONS_MAPPING_PER_REGION] (
    [ID]                     INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_VWS_RESTRICTIONS_MAPPING_PER_REGION]) NOT NULL,
    [REGION_ID]              VARCHAR (100) NULL,
    [RESTRICTION_IDENTIFIER] VARCHAR (100) NULL,
    [VALID_FROM]             VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]     DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VWS_RESTRICTIONS_MAPPING_PER_REGION_STAGE]
    ON [VWSSTAGE].[VWS_RESTRICTIONS_MAPPING_PER_REGION]([DATE_LAST_INSERTED] ASC);

