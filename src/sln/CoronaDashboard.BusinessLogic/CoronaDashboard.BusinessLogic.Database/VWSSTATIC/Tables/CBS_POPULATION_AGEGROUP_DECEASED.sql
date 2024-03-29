﻿CREATE TABLE [VWSSTATIC].[CBS_POPULATION_AGEGROUP_DECEASED] (
    [ID]                     INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTATIC_CBS_POPULATION_AGEGROUP_DECEASED]) NOT NULL,
    [AGEGROUP]               VARCHAR (10)    NULL,
    [DATUM_PEILING]          DATE            NULL,
    [POPULATIE]              INT             NULL,
    [POPULATIE_TOTAL]        INT             NULL,
    [INHABITANTS_PERCENTAGE] DECIMAL (19, 3) NULL,
    [DATE_LAST_INSERTED]     DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCI_DLI_VWSSTATIC_CBS_POPULATION_AGEGROUP_DECEASED]
    ON [VWSSTATIC].[CBS_POPULATION_AGEGROUP_DECEASED]([DATUM_PEILING] ASC, [AGEGROUP] ASC, [POPULATIE] ASC);


GO
CREATE CLUSTERED INDEX [CI_DLI_VWSSTATIC_CBS_POPULATION_AGEGROUP_DECEASED]
    ON [VWSSTATIC].[CBS_POPULATION_AGEGROUP_DECEASED]([DATE_LAST_INSERTED] ASC);

