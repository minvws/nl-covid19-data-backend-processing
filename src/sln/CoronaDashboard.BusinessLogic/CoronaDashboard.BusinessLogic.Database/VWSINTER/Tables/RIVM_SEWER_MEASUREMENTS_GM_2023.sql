CREATE TABLE [VWSINTER].[RIVM_SEWER_MEASUREMENTS_GM_2023] (
    [ID]                             INT           IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED]             DATETIME      DEFAULT (getdate()) NOT NULL,
    [VERSION]                        INT           NULL,
    [DATE_OF_REPORT]                 DATETIME      NULL,
    [YEAR]                           INT           NULL,
    [WEEK]                           INT           NULL,
    [START_DATE]                     DATETIME      NULL,
    [END_DATE]                       DATETIME      NULL,
    [REGION_CODE]                    VARCHAR (256) NULL,
    [REGION_NAME]                    VARCHAR (256) NULL,
    [RNA_FLOW_PER_100000_WEEKLYMEAN] BIGINT        NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_RIVM_SEWER_MEASUREMENTS_GM_2023]
    ON [VWSINTER].[RIVM_SEWER_MEASUREMENTS_GM_2023]([DATE_LAST_INSERTED] ASC);

