﻿CREATE TABLE [VWSSTATIC].[CBS_POPULATION_NL] (
    [ID]                 INT      DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTATIC_CBS_POPULATION_NL]) NOT NULL,
    [DATUM_PEILING]      DATE     NULL,
    [POPULATIE]          INT      NULL,
    [DATE_LAST_INSERTED] DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE CLUSTERED INDEX [CI_DLI_VWSSTATIC_CBS_POPULATION_NL]
    ON [VWSSTATIC].[CBS_POPULATION_NL]([DATE_LAST_INSERTED] ASC);

