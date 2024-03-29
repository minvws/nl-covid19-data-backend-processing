﻿CREATE TABLE [VWSDEST].[SEWER_MEASUREMENTS_PER_REGION] (
    [ID]                          INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_SEWER_MEASUREMENTS_PER_REGION_2021]) NOT NULL,
    [WEEK_UNIX]                   BIGINT          NULL,
    [VRCODE]                      VARCHAR (100)   NULL,
    [AVERAGE_RNA_FLOW_PER_100000] DECIMAL (16, 2) NULL,
    [NUMBER_OF_MEASUREMENTS]      INT             NULL,
    [NUMBER_OF_LOCATIONS]         INT             NULL,
    [TOTAL_LOCATIONS]             INT             NULL,
    [DATE_LAST_INSERTED]          DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_DLI_SEWER_MEASUREMENTS_PER_REGION]
    ON [VWSDEST].[SEWER_MEASUREMENTS_PER_REGION]([DATE_LAST_INSERTED] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_SEWER_MEASUREMENTS_PER_REGION_VRCODE_DATE_LAST_INSERTED_1]
    ON [VWSDEST].[SEWER_MEASUREMENTS_PER_REGION]([VRCODE] ASC, [DATE_LAST_INSERTED] ASC)
    INCLUDE([WEEK_UNIX]);


GO
CREATE NONCLUSTERED INDEX [IX_SEWER_MEASUREMENTS_PER_REGION_VRCODE_DATE_LAST_INSERTED]
    ON [VWSDEST].[SEWER_MEASUREMENTS_PER_REGION]([VRCODE] ASC, [DATE_LAST_INSERTED] ASC)
    INCLUDE([WEEK_UNIX], [AVERAGE_RNA_FLOW_PER_100000], [NUMBER_OF_MEASUREMENTS], [NUMBER_OF_LOCATIONS], [TOTAL_LOCATIONS]);


GO
CREATE NONCLUSTERED INDEX [IX_SEWER_MEASUREMENTS_PER_REGION_VRCODE]
    ON [VWSDEST].[SEWER_MEASUREMENTS_PER_REGION]([VRCODE] ASC)
    INCLUDE([WEEK_UNIX], [AVERAGE_RNA_FLOW_PER_100000], [NUMBER_OF_MEASUREMENTS], [NUMBER_OF_LOCATIONS], [TOTAL_LOCATIONS], [DATE_LAST_INSERTED]);

