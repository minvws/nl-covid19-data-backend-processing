CREATE TABLE [VWSDEST].[SEWER_BASE] (
    [ID]                      INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_SEWER_BASE_2021]) NOT NULL,
    [WEEK]                    INT           NULL,
    [WEEK_UNIX]               BIGINT        NULL,
    [DATE_MEASUREMENT]        DATETIME      NULL,
    [RWZI_AWZI_CODE]          INT           NULL,
    [RWZI_AWZI_NAME]          VARCHAR (100) NULL,
    [GM_CODE]                 VARCHAR (100) NULL,
    [RNA_PER_ML]              BIGINT        NULL,
    [RNA_FLOW_PER_100000]     BIGINT        NULL,
    [COUNT_DAILY_MEASUREMENT] INT           NULL,
    [DATE_LAST_INSERTED]      DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_DLI_SEWER_BASE]
    ON [VWSDEST].[SEWER_BASE]([DATE_LAST_INSERTED] ASC);

