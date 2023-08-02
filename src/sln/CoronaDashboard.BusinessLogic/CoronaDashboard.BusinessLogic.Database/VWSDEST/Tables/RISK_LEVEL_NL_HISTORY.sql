CREATE TABLE [VWSDEST].[RISK_LEVEL_NL_HISTORY] (
    [ID]                   INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_RISK_LEVEL_NL_HISTORY]) NOT NULL,
    [HOSP_WEEK_START]      DATETIME        NULL,
    [HOSP_WEEK_END]        DATETIME        NULL,
    [HOSP_7D_AVG]          DECIMAL (19, 3) NULL,
    [HOSP_INSERTION]       DATETIME        NULL,
    [IC_WEEK_START]        DATETIME        NULL,
    [IC_WEEK_END]          DATETIME        NULL,
    [IC_7D_AVG]            DECIMAL (19, 3) NULL,
    [IC_INSERTION]         DATETIME        NULL,
    [RISK_LEVEL_1]         VARCHAR (100)   NULL,
    [RISK_LEVEL_2]         VARCHAR (100)   NULL,
    [RISK_LEVEL_3]         VARCHAR (100)   NULL,
    [IC_LOWER]             INT             NULL,
    [IC_UPPER]             INT             NULL,
    [HOSP_LOWER]           INT             NULL,
    [HOSP_UPPER]           INT             NULL,
    [THRESHOLD_VALID_FROM] DATETIME        NULL,
    [RISK_LEVEL_HOSP]      INT             NULL,
    [RISK_LEVEL_IC]        INT             NULL,
    [RISK_LEVEL]           INT             NULL,
    [VALID_FROM]           DATETIME        NULL,
    [VALID]                INT             NULL,
    [DATE_LAST_INSERTED]   DATETIME        DEFAULT (getdate()) NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE CLUSTERED INDEX [CI_DLI_VWSDEST_RISK_LEVEL_NL_HISTORY]
    ON [VWSDEST].[RISK_LEVEL_NL_HISTORY]([DATE_LAST_INSERTED] ASC);

