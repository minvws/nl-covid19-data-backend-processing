CREATE TABLE [VWSSTAGE].[RIVM_VACCINATION_PLANNED_NL] (
    [ID]                 BIGINT        IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    [CATEGORY]           VARCHAR (100) NULL,
    [KEY]                VARCHAR (100) NULL,
    [VALUE]              VARCHAR (100) NULL,
    [GROUP]              VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

