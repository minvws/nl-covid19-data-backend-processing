﻿CREATE TABLE [VWSSTAGE].[LNAZ_HOSPITAL_BED_OCCUPANCY] (
    [ID]                           INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_LNAZ_HOSPITAL_BED_OCCUPANCY]) NOT NULL,
    [DATUM]                        VARCHAR (100) NULL,
    [IC_BEDDEN_COVID]              VARCHAR (100) NULL,
    [IC_BEDDEN_NON_COVID]          VARCHAR (100) NULL,
    [KLINIEK_BEDDEN]               VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]           DATETIME      DEFAULT (getdate()) NULL,
    [IC_NIEUWE_OPNAMES_COVID]      VARCHAR (100) NULL,
    [KLINIEK_NIEUWE_OPNAMES_COVID] VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_LNAZ_HOSPITAL_BED_OCCUPANCY_DLI]
    ON [VWSSTAGE].[LNAZ_HOSPITAL_BED_OCCUPANCY]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATUM], [IC_BEDDEN_COVID], [IC_BEDDEN_NON_COVID], [KLINIEK_BEDDEN]);

