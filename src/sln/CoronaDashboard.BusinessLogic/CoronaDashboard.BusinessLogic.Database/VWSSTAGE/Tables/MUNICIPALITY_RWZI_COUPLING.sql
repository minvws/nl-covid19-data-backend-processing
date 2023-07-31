﻿CREATE TABLE [VWSSTAGE].[MUNICIPALITY_RWZI_COUPLING] (
    [ID]                 INT           IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NOT NULL,
    [VERSIE]             VARCHAR (256) NOT NULL,
    [DATUM_BESTAND]      VARCHAR (256) NOT NULL,
    [DATUM_HERINDELING]  VARCHAR (256) NOT NULL,
    [REGIO_CODE]         VARCHAR (256) NOT NULL,
    [REGIO_CODE_INT]     VARCHAR (256) NOT NULL,
    [REGIO_NAAM]         VARCHAR (256) NOT NULL,
    [RWZI_CODE]          VARCHAR (256) NOT NULL,
    [RWZI_NAAM]          VARCHAR (256) NOT NULL,
    [ACTIEF]             VARCHAR (256) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

