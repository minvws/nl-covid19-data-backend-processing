﻿CREATE TABLE [VWSINTER].[ELDERLY_AT_HOME] (
    [ID]                         INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_ELDERLY_AT_HOME]) NOT NULL,
    [DATE_OF_REPORT]             DATETIME      NULL,
    [DATE_OF_STATISTIC_REPORTED] DATETIME      NULL,
    [SECURITY_REGION_CODE]       VARCHAR (100) NULL,
    [TOTAL_CASES_REPORTED]       INT           NULL,
    [TOTAL_DECEASED_REPORTED]    INT           NULL,
    [DATE_LAST_INSERTED]         DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VWSINTER_ELDERLY_AT_HOME]
    ON [VWSINTER].[ELDERLY_AT_HOME]([DATE_LAST_INSERTED] ASC, [DATE_OF_STATISTIC_REPORTED] ASC, [SECURITY_REGION_CODE] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_ELDERLY_AT_HOME_DLI]
    ON [VWSINTER].[ELDERLY_AT_HOME]([DATE_LAST_INSERTED] ASC)
    INCLUDE([SECURITY_REGION_CODE], [TOTAL_CASES_REPORTED], [TOTAL_DECEASED_REPORTED]);


GO
CREATE NONCLUSTERED INDEX [IX_ELDERLY_AT_HOME_DATE_OF_STATISTIC_REPORTED]
    ON [VWSINTER].[ELDERLY_AT_HOME]([DATE_OF_STATISTIC_REPORTED] ASC)
    INCLUDE([SECURITY_REGION_CODE], [TOTAL_CASES_REPORTED], [TOTAL_DECEASED_REPORTED], [DATE_LAST_INSERTED]);


GO
CREATE NONCLUSTERED INDEX [IX_ELDERLY_AT_HOME_DATE_LAST_INSERTED_DATE_OF_STATISTIC_REPORTED]
    ON [VWSINTER].[ELDERLY_AT_HOME]([DATE_LAST_INSERTED] ASC, [DATE_OF_STATISTIC_REPORTED] ASC)
    INCLUDE([SECURITY_REGION_CODE], [TOTAL_CASES_REPORTED], [TOTAL_DECEASED_REPORTED]);

