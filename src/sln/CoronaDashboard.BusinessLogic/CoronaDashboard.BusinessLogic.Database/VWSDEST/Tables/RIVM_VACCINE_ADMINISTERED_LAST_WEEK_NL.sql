﻿CREATE TABLE [VWSDEST].[RIVM_VACCINE_ADMINISTERED_LAST_WEEK_NL] (
    [ID]                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    [DATE_OF_REPORT]     DATETIME2 (7) NULL,
    [DATE_FIRST_DAY]     DATETIME2 (7) NULL,
    [VALUE_TYPE]         VARCHAR (50)  NULL,
    [VALUE_NAME]         VARCHAR (50)  NULL,
    [REPORT_STATUS]      VARCHAR (50)  NULL,
    [VALUE]              INT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_DLI_RIVM_VACCINE_ADMINISTERED_LAST_WEEK_NL]
    ON [VWSDEST].[RIVM_VACCINE_ADMINISTERED_LAST_WEEK_NL]([DATE_LAST_INSERTED] ASC);

