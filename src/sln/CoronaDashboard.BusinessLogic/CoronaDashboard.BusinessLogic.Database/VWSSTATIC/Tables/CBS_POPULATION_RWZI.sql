CREATE TABLE [VWSSTATIC].[CBS_POPULATION_RWZI] (
    [ID]                 INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTATIC_CBS_POPULATION_RWZI]) NOT NULL,
    [RWZI_CODE]          VARCHAR (100)   NULL,
    [RWZI_NAAM]          VARCHAR (100)   NULL,
    [STARTDATUM]         DATE            NULL,
    [EINDDATUM]          DATE            NULL,
    [INWONERS]           INT             NULL,
    [REGIO_TYPE]         VARCHAR (100)   NULL,
    [REGIO_CODE]         VARCHAR (100)   NULL,
    [REGIO_NAAM]         VARCHAR (100)   NULL,
    [AANDEEL]            DECIMAL (19, 3) NULL,
    [DATE_LAST_INSERTED] DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

