﻿CREATE TABLE [VWSINTER].[RIVM_SEWER_MEASUREMENTS_ARCHIVE] (
    [ID]                            INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_SEWER_MEASUREMENTS]) NOT NULL,
    [DATE_MEASUREMENT]              DATETIME        NULL,
    [RWZI_AWZI_CODE]                BIGINT          NULL,
    [RWZI_AWZI_NAME]                VARCHAR (100)   NULL,
    [X_COORDINATE]                  DECIMAL (16, 2) NULL,
    [Y_COORDINATE]                  DECIMAL (16, 2) NULL,
    [POSTAL_CODE]                   VARCHAR (100)   NULL,
    [SECURITY_REGION_CODE]          VARCHAR (100)   NULL,
    [SECURITY_REGION_NAME]          VARCHAR (100)   NULL,
    [PERCENTAGE_IN_SECURITY_REGION] FLOAT (53)      NULL,
    [RNA_PER_ML]                    BIGINT          NULL,
    [REPRESENTATIVE_MEASUREMENT]    VARCHAR (100)   NULL,
    [DATE_LAST_INSERTED]            DATETIME        DEFAULT (getdate()) NULL,
    [RNA_FLOW_PER_100000]           BIGINT          NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_RIVM_SEWER_MEASUREMENTS_DM]
    ON [VWSINTER].[RIVM_SEWER_MEASUREMENTS_ARCHIVE]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_MEASUREMENT], [RWZI_AWZI_CODE], [RWZI_AWZI_NAME], [SECURITY_REGION_CODE], [REPRESENTATIVE_MEASUREMENT]);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_RIVM_SEWER_MEASUREMENTS]
    ON [VWSINTER].[RIVM_SEWER_MEASUREMENTS_ARCHIVE]([DATE_LAST_INSERTED] ASC);

