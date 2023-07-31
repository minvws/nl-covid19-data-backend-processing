CREATE TABLE [VWSINTER].[RIVM_SITUATIONS] (
    [ID]                               INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_SITUATIONS]) NOT NULL,
    [VERSION]                          INT           NULL,
    [DATE_OF_REPORT]                   DATETIME      NULL,
    [DATE_OF_PUBLICATION]              DATETIME      NULL,
    [SECURITY_REGION_NAME]             VARCHAR (100) NULL,
    [SECURITY_REGION_CODE]             VARCHAR (100) NULL,
    [SOURCE_AND_CONTACT_TRACING_PHASE] VARCHAR (100) NULL,
    [TOTAL_REPORTED]                   INT           NULL,
    [REPORTS_WITH_SETTINGS]            INT           NULL,
    [SETTING_REPORTED]                 VARCHAR (100) NULL,
    [NUMBER_SETTINGS_REPORTED]         INT           NULL,
    [DATE_LAST_INSERTED]               DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

