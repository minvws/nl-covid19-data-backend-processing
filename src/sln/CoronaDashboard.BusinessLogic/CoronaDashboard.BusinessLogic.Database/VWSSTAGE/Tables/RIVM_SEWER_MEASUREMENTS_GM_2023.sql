CREATE TABLE [VWSSTAGE].[RIVM_SEWER_MEASUREMENTS_GM_2023] (
    [ID]                             INT           IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED]             DATETIME      DEFAULT (getdate()) NOT NULL,
    [VERSION]                        VARCHAR (256) NULL,
    [DATE_OF_REPORT]                 VARCHAR (256) NULL,
    [YEAR]                           VARCHAR (256) NULL,
    [WEEK]                           VARCHAR (256) NULL,
    [START_DATE]                     VARCHAR (256) NULL,
    [END_DATE]                       VARCHAR (256) NULL,
    [REGION_CODE]                    VARCHAR (256) NULL,
    [REGION_NAME]                    VARCHAR (256) NULL,
    [RNA_FLOW_PER_100000_WEEKLYMEAN] VARCHAR (256) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_RIVM_SEWER_MEASUREMENTS_GM_2023]
    ON [VWSSTAGE].[RIVM_SEWER_MEASUREMENTS_GM_2023]([DATE_LAST_INSERTED] ASC);

