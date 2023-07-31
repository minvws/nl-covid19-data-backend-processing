﻿CREATE TABLE [VWSSTAGE].[CBS_POPULATION_BASE] (
    [ID]                    INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_CBS_POPULATION_BASE]) NOT NULL,
    [GEMEENTE_CODE]         VARCHAR (100) NULL,
    [GEMEENTE]              VARCHAR (100) NULL,
    [LEEFTIJD]              VARCHAR (100) NULL,
    [GESLACHT]              VARCHAR (100) NULL,
    [DATUM_PEILING]         VARCHAR (100) NULL,
    [POPULATIE]             VARCHAR (100) NULL,
    [VEILIGHEIDSREGIO_CODE] VARCHAR (100) NULL,
    [VEILIGHEIDSREGIO_NAAM] VARCHAR (100) NULL,
    [PROVINCIE_CODE]        VARCHAR (100) NULL,
    [PROVINCIE_NAAM]        VARCHAR (100) NULL,
    [GGD_CODE]              VARCHAR (100) NULL,
    [GGD_NAAM]              VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]    DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_DLI_VWSSTAGE_CBS_POPULATION_BASE]
    ON [VWSSTAGE].[CBS_POPULATION_BASE]([DATE_LAST_INSERTED] ASC);


GO
CREATE NONCLUSTERED INDEX [NCI_DLI_VWSSTAGE_CIMS_VACCINATED_AGE_GROUP]
    ON [VWSSTAGE].[CBS_POPULATION_BASE]([DATE_LAST_INSERTED] ASC, [GEMEENTE_CODE] ASC, [GEMEENTE] ASC, [LEEFTIJD] ASC, [GESLACHT] ASC, [DATUM_PEILING] ASC, [POPULATIE] ASC, [VEILIGHEIDSREGIO_CODE] ASC, [VEILIGHEIDSREGIO_NAAM] ASC, [PROVINCIE_CODE] ASC, [PROVINCIE_NAAM] ASC, [GGD_CODE] ASC, [GGD_NAAM] ASC);


GO
CREATE CLUSTERED INDEX [CI_DLI_VWSSTAGE_CBS_POPULATION_BASE]
    ON [VWSSTAGE].[CBS_POPULATION_BASE]([DATE_LAST_INSERTED] ASC);

