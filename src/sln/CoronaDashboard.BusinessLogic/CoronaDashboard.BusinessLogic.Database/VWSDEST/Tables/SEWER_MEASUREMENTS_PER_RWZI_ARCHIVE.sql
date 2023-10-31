﻿CREATE TABLE [VWSDEST].[SEWER_MEASUREMENTS_PER_RWZI_ARCHIVE] (
    [ID]                    INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_SEWER_MEASUREMENTS_PER_RWZI]) NOT NULL,
    [DATE_MEASUREMENT]      DATETIME        NULL,
    [DATE_MEASUREMENT_UNIX] BIGINT          NULL,
    [WEEK]                  INT             NULL,
    [RWZI_AWZI_CODE]        VARCHAR (100)   NULL,
    [RWZI_AWZI_NAME]        VARCHAR (100)   NULL,
    [VRCODE]                VARCHAR (100)   NULL,
    [VRNAAM]                VARCHAR (100)   NULL,
    [RNA_PER_ML]            DECIMAL (16, 2) NULL,
    [DATE_LAST_INSERTED]    DATETIME        DEFAULT (getdate()) NULL,
    [RNA_FLOW_PER_100000]   DECIMAL (16, 2) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

GO
CREATE NONCLUSTERED INDEX [IX_SEWER_MEASUREMENTS_PER_RWZI_RA_DM]
    ON [VWSDEST].[SEWER_MEASUREMENTS_PER_RWZI_ARCHIVE]([RWZI_AWZI_CODE] ASC, [DATE_MEASUREMENT] ASC)
    INCLUDE([DATE_MEASUREMENT_UNIX], [RWZI_AWZI_NAME], [RNA_FLOW_PER_100000], [DATE_LAST_INSERTED]);


GO
CREATE NONCLUSTERED INDEX [IX_SEWER_MEASUREMENTS_PER_RWZI_RA_DLI]
    ON [VWSDEST].[SEWER_MEASUREMENTS_PER_RWZI_ARCHIVE]([RWZI_AWZI_CODE] ASC, [DATE_MEASUREMENT] ASC)
    INCLUDE([DATE_MEASUREMENT_UNIX], [RWZI_AWZI_NAME], [VRCODE], [VRNAAM], [RNA_FLOW_PER_100000]);


GO
CREATE NONCLUSTERED INDEX [IX_SEWER_MEASUREMENTS_PER_RWZI_DLI_VR]
    ON [VWSDEST].[SEWER_MEASUREMENTS_PER_RWZI_ARCHIVE]([DATE_LAST_INSERTED] ASC, [VRCODE] ASC)
    INCLUDE([DATE_MEASUREMENT], [DATE_MEASUREMENT_UNIX], [RNA_FLOW_PER_100000], [RWZI_AWZI_CODE], [RWZI_AWZI_NAME], [VRNAAM]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_SEWER_MEASUREMENTS_PER_RWZI_DLI_2]
    ON [VWSDEST].[SEWER_MEASUREMENTS_PER_RWZI_ARCHIVE]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_MEASUREMENT], [DATE_MEASUREMENT_UNIX], [RWZI_AWZI_CODE], [RWZI_AWZI_NAME], [VRCODE], [VRNAAM], [RNA_PER_ML]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_SEWER_MEASUREMENTS_PER_RWZI_DLI]
    ON [VWSDEST].[SEWER_MEASUREMENTS_PER_RWZI_ARCHIVE]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_MEASUREMENT], [DATE_MEASUREMENT_UNIX], [WEEK], [RWZI_AWZI_CODE], [RWZI_AWZI_NAME], [VRCODE], [VRNAAM], [RNA_PER_ML]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_SEWER_MEASUREMENTS_PER_RWZI]
    ON [VWSDEST].[SEWER_MEASUREMENTS_PER_RWZI_ARCHIVE]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_MEASUREMENT], [DATE_MEASUREMENT_UNIX], [WEEK], [RWZI_AWZI_CODE], [RWZI_AWZI_NAME], [VRCODE], [VRNAAM], [RNA_PER_ML]);

