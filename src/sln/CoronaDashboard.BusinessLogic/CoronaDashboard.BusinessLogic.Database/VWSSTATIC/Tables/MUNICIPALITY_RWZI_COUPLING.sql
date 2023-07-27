CREATE TABLE [VWSSTATIC].[MUNICIPALITY_RWZI_COUPLING] (
    [ID]                 INT           IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NOT NULL,
    [VERSIE]             INT           NOT NULL,
    [DATUM_BESTAND]      DATETIME      NOT NULL,
    [DATUM_HERINDELING]  DATETIME      NOT NULL,
    [REGIO_CODE]         VARCHAR (256) NOT NULL,
    [REGIO_CODE_INT]     INT           NOT NULL,
    [REGIO_NAAM]         VARCHAR (256) NOT NULL,
    [RWZI_CODE]          INT           NOT NULL,
    [RWZI_NAAM]          VARCHAR (256) NOT NULL,
    [ACTIEF]             BIT           NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

