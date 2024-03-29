﻿CREATE TABLE [VWSSTATIC].[CBS_POPULATION_VR] (
    [ID]                 INT          DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTATIC_CBS_POPULATION_VR]) NOT NULL,
    [VR_CODE]            VARCHAR (10) NULL,
    [DATUM_PEILING]      DATE         NULL,
    [POPULATIE]          INT          NULL,
    [DATE_LAST_INSERTED] DATETIME     DEFAULT (getdate()) NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE CLUSTERED INDEX [CI_DLI_VWSSTATIC_CBS_POPULATION_VR]
    ON [VWSSTATIC].[CBS_POPULATION_VR]([DATE_LAST_INSERTED] ASC);

