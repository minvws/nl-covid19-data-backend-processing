﻿CREATE TABLE [VWSSTAGE].[RIVM_MUTATIONS] (
    [ID]                            INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_RIVM_MUTATIONS]) NOT NULL,
    [VERSION]                       VARCHAR (100) NULL,
    [DATE_OF_REPORT]                VARCHAR (100) NULL,
    [DATE_OF_STATISTICS_WEEK_START] VARCHAR (100) NULL,
    [VARIANT_CODE]                  VARCHAR (100) NULL,
    [VARIANT_NAME]                  VARCHAR (100) NULL,
    [ECDC_CATEGORY]                 VARCHAR (100) NULL,
    [SAMPLE_SIZE]                   VARCHAR (100) NULL,
    [VARIANT_CASES]                 VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]            DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_STAGE_RIVM_MUTATIONS]
    ON [VWSSTAGE].[RIVM_MUTATIONS]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_OF_REPORT], [DATE_OF_STATISTICS_WEEK_START], [VARIANT_CODE], [VARIANT_NAME], [ECDC_CATEGORY], [SAMPLE_SIZE], [VARIANT_CASES]);

