CREATE TABLE [VWSINTER].[VWS_BEHAVIOR] (
    [ID]                              INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_VWS_BEHAVIOR]) NOT NULL,
    [DATE_OF_REPORT]                  DATETIME        NULL,
    [DATE_OF_MEASUREMENT]             DATETIME        NULL,
    [WAVE]                            INT             NULL,
    [REGION_CODE]                     VARCHAR (100)   NULL,
    [REGION_NAME]                     VARCHAR (100)   NULL,
    [SUBGROUP_CATEGORY]               VARCHAR (100)   NULL,
    [SUBGROUP]                        VARCHAR (100)   NULL,
    [INDICATOR_CATEGORY]              VARCHAR (100)   NULL,
    [INDICATOR]                       VARCHAR (100)   NULL,
    [SAMPLE_SIZE]                     INT             NULL,
    [FIGURE_TYPE]                     VARCHAR (100)   NULL,
    [VALUE]                           DECIMAL (16, 2) NULL,
    [LOWER_LIMIT]                     DECIMAL (16, 2) NULL,
    [UPPER_LIMIT]                     DECIMAL (16, 2) NULL,
    [CHANGE_WRT_PREVIOUS_MEASUREMENT] INT             NULL,
    [DATE_LAST_INSERTED]              DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_VWS_BEHAVIOR_DLI_DOM]
    ON [VWSINTER].[VWS_BEHAVIOR]([DATE_LAST_INSERTED] ASC, [DATE_OF_MEASUREMENT] ASC)
    INCLUDE([INDICATOR], [REGION_CODE], [SUBGROUP]);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_VWS_BEHAVIOR]
    ON [VWSINTER].[VWS_BEHAVIOR]([DATE_LAST_INSERTED] ASC)
    INCLUDE([INDICATOR], [REGION_CODE], [SUBGROUP]);

