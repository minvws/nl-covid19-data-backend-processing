﻿CREATE TABLE [VWSSTAGE].[ELDERLY_AT_HOME] (
    [ID]                         INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_ELDERLY_AT_HOME]) NOT NULL,
    [DATE_OF_REPORT]             VARCHAR (100) NULL,
    [DATE_OF_STATISTIC_REPORTED] VARCHAR (100) NULL,
    [SECURITY_REGION_CODE]       VARCHAR (100) NULL,
    [SECURITY_REGION]            VARCHAR (100) NULL,
    [TOTAL_CASES_REPORTED]       VARCHAR (100) NULL,
    [TOTAL_DECEASED_REPORTED]    VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]         DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VWSSTAGE_ELDERLY_AT_HOME]
    ON [VWSSTAGE].[ELDERLY_AT_HOME]([DATE_LAST_INSERTED] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_ELDERLY_AT_HOME_DLI]
    ON [VWSSTAGE].[ELDERLY_AT_HOME]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_OF_REPORT], [DATE_OF_STATISTIC_REPORTED], [SECURITY_REGION_CODE], [TOTAL_CASES_REPORTED], [TOTAL_DECEASED_REPORTED]);

