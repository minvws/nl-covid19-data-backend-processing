﻿CREATE TABLE [VWSINTER].[RIVM_MUTATIONS] (
    [ID]                            INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_MUTATIONS]) NOT NULL,
    [VERSION]                       INT           NULL,
    [DATE_OF_REPORT]                DATETIME      NULL,
    [DATE_OF_STATISTICS_WEEK_START] DATETIME      NULL,
    [VARIANT_CODE]                  VARCHAR (100) NULL,
    [VARIANT_NAME]                  VARCHAR (100) NULL,
    [ECDC_CATEGORY]                 VARCHAR (100) NULL,
    [SAMPLE_SIZE]                   INT           NULL,
    [VARIANT_CASES]                 INT           NULL,
    [DATE_LAST_INSERTED]            DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_RIVM_MUTATIONS]
    ON [VWSINTER].[RIVM_MUTATIONS]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_OF_REPORT], [DATE_OF_STATISTICS_WEEK_START], [VARIANT_CODE], [VARIANT_NAME], [ECDC_CATEGORY], [SAMPLE_SIZE], [VARIANT_CASES]);

