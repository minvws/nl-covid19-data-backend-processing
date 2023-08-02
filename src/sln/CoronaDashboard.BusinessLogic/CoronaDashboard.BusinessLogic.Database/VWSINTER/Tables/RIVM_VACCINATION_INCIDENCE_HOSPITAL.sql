﻿CREATE TABLE [VWSINTER].[RIVM_VACCINATION_INCIDENCE_HOSPITAL] (
    [ID]                              INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_VACCINATION_INCIDENCE_HOSPITAL]) NOT NULL,
    [DATUM_PERIODE_START]             DATETIME        NULL,
    [DATUM_PERIODE_EINDE]             DATETIME        NULL,
    [lEEFTIJDSCOHORT_CATEGORIE]       INT             NULL,
    [LEEFTIJDSCOHORT_CATEGORIE_LABEL] VARCHAR (100)   NULL,
    [VACC_STATUS]                     VARCHAR (100)   NULL,
    [INCIDENTIE_OPNAMES_GEM]          DECIMAL (10, 2) NULL,
    [DATE_LAST_INSERTED]              DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VWSINTER_VACCINATION_INCIDENCE_HOSPITAL]
    ON [VWSINTER].[RIVM_VACCINATION_INCIDENCE_HOSPITAL]([DATE_LAST_INSERTED] ASC);

