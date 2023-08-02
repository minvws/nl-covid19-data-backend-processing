﻿CREATE TABLE [VWSSTAGE].[NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS] (
    [ID]                    INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS]) NOT NULL,
    [INCIDENTIE_PER_100000] VARCHAR (100) NULL,
    [BOVENGRENS]            VARCHAR (100) NULL,
    [WEEK]                  VARCHAR (100) NULL,
    [DIAGNOSE]              VARCHAR (100) NULL,
    [JAAR]                  VARCHAR (100) NULL,
    [GESCHAT_AANTAL]        VARCHAR (100) NULL,
    [ONDERGRENS]            VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]    DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS]
    ON [VWSSTAGE].[NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS]([DATE_LAST_INSERTED] ASC);

