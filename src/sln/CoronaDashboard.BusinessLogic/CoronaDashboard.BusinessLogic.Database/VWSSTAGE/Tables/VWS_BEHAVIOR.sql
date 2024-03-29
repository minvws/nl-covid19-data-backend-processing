﻿CREATE TABLE [VWSSTAGE].[VWS_BEHAVIOR] (
    [ID]                              INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_VWS_BEHAVIOR]) NOT NULL,
    [DATE_OF_REPORT]                  VARCHAR (100) NULL,
    [DATE_OF_MEASUREMENT]             VARCHAR (100) NULL,
    [WAVE]                            VARCHAR (100) NULL,
    [REGION_CODE]                     VARCHAR (100) NULL,
    [REGION_NAME]                     VARCHAR (100) NULL,
    [SUBGROUP_CATEGORY]               VARCHAR (100) NULL,
    [SUBGROUP]                        VARCHAR (100) NULL,
    [INDICATOR_CATEGORY]              VARCHAR (100) NULL,
    [INDICATOR]                       VARCHAR (100) NULL,
    [SAMPLE_SIZE]                     VARCHAR (100) NULL,
    [FIGURE_TYPE]                     VARCHAR (100) NULL,
    [VALUE]                           VARCHAR (100) NULL,
    [LOWER_LIMIT]                     VARCHAR (100) NULL,
    [UPPER_LIMIT]                     VARCHAR (100) NULL,
    [CHANGE_WRT_PREVIOUS_MEASUREMENT] VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]              DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_STAGE_VWS_BEHAVIOR_DLI]
    ON [VWSSTAGE].[VWS_BEHAVIOR]([DATE_LAST_INSERTED] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_STAGE_VWS_BEHAVIOR]
    ON [VWSSTAGE].[VWS_BEHAVIOR]([DATE_LAST_INSERTED] ASC);

