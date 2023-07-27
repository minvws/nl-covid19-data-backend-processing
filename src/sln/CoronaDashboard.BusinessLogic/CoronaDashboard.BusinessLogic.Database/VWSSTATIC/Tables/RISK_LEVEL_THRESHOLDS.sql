CREATE TABLE [VWSSTATIC].[RISK_LEVEL_THRESHOLDS] (
    [ID]                 INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTATIC_CBS_POPULATION_RWZI]) NOT NULL,
    [RISK_LEVEL_1]       VARCHAR (100) NULL,
    [RISK_LEVEL_2]       VARCHAR (100) NULL,
    [RISK_LEVEL_3]       VARCHAR (100) NULL,
    [IC_LOWER]           INT           NULL,
    [IC_UPPER]           INT           NULL,
    [HOSP_LOWER]         INT           NULL,
    [HOSP_UPPER]         INT           NULL,
    [GELDIG VANAF]       DATE          NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

