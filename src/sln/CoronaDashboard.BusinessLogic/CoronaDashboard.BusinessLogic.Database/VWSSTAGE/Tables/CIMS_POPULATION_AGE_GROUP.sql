﻿CREATE TABLE [VWSSTAGE].[CIMS_POPULATION_AGE_GROUP] (
    [ID]                 INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_CIMS_POPULATION_AGE_GROUP]) NOT NULL,
    [BIRTH_COHORT]       VARCHAR (100) NULL,
    [BEVOLKING]          VARCHAR (100) NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCI_DLI_VWSSTAGE_CIMS_POPULATION_AGE_GROUP]
    ON [VWSSTAGE].[CIMS_POPULATION_AGE_GROUP]([DATE_LAST_INSERTED] ASC, [BIRTH_COHORT] ASC)
    INCLUDE([BEVOLKING]);


GO
CREATE CLUSTERED INDEX [CI_DLI_VWSSTAGE_CIMS_POPULATION_AGE_GROUP]
    ON [VWSSTAGE].[CIMS_POPULATION_AGE_GROUP]([DATE_LAST_INSERTED] ASC);

