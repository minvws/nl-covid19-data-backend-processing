CREATE TABLE [VWSARCHIVE].[SEWER_MEASUREMENTS_PER_MUNICIPALITY] (
    [ID]                          INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSARCHIVE_SEWER_MEASUREMENTS_PER_MUNICIPALITY]) NOT NULL,
    [WEEK]                        INT             NULL,
    [WEEK_UNIX]                   BIGINT          NULL,
    [GMCODE]                      VARCHAR (100)   NULL,
    [AVERAGE]                     DECIMAL (16, 2) NULL,
    [DATE_LAST_INSERTED]          DATETIME        DEFAULT (getdate()) NULL,
    [NUMBER_OF_MEASUREMENTS]      INT             NULL,
    [NUMBER_OF_LOCATIONS]         INT             NULL,
    [AVERAGE_RNA_FLOW_PER_100000] DECIMAL (16, 2) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

