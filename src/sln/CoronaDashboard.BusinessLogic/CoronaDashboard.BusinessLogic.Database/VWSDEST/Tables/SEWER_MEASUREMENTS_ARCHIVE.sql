CREATE TABLE [VWSDEST].[SEWER_MEASUREMENTS_ARCHIVE] (
    [ID]                          INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_SEWER_MEASUREMENTS]) NOT NULL,
    [WEEK_UNIX]                   BIGINT          NULL,
    [AVERAGE]                     DECIMAL (16, 2) NULL,
    [NUMBER_OF_MEASUREMENTS]      INT             NULL,
    [DATE_LAST_INSERTED]          DATETIME        DEFAULT (getdate()) NULL,
    [NUMBER_OF_LOCATIONS]         INT             NULL,
    [AVERAGE_RNA_FLOW_PER_100000] DECIMAL (16, 2) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

