﻿CREATE TABLE [VWSDEST].[RIVM_AGEGROUP_TOTALS] (
    [ID]                 INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_RIVM_AGEGROUP_TOTALS]) NOT NULL,
    [DATE_FILE]          DATETIME      NULL,
    [AGEGROUP]           VARCHAR (100) NULL,
    [INFECTED]           INT           NULL,
    [DECEASED]           INT           NULL,
    [HOSPITALIZED]       INT           NULL,
    [INFECTED_TOTAL]     INT           NULL,
    [DECEASED_TOTAL]     INT           NULL,
    [HOSPITALIZED_TOTAL] INT           NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_RIVM_AGEGROUP_TOTALS]
    ON [VWSDEST].[RIVM_AGEGROUP_TOTALS]([DATE_LAST_INSERTED] ASC, [DATE_FILE] ASC, [AGEGROUP] ASC)
    INCLUDE([INFECTED], [DECEASED], [HOSPITALIZED], [INFECTED_TOTAL], [DECEASED_TOTAL], [HOSPITALIZED_TOTAL]);

