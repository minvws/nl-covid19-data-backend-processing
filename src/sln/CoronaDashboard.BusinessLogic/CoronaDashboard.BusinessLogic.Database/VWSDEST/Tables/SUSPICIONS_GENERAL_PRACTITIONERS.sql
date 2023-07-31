CREATE TABLE [VWSDEST].[SUSPICIONS_GENERAL_PRACTITIONERS] (
    [ID]                 INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_SUSPICIONS_GENERAL_PRACTITIONERS]) NOT NULL,
    [DIAGNOSE]           VARCHAR (100)   NULL,
    [JAAR]               INT             NULL,
    [WEEK]               INT             NULL,
    [WEEK_UNIX]          BIGINT          NULL,
    [INCIDENTIE]         DECIMAL (16, 2) NULL,
    [BOVENGRENS]         INT             NULL,
    [GESCHAT_AANTAL]     INT             NULL,
    [ONDERGRENS]         INT             NULL,
    [DATE_LAST_INSERTED] DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

