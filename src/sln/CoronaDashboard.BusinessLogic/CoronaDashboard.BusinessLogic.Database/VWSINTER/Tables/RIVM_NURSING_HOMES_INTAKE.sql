﻿CREATE TABLE [VWSINTER].[RIVM_NURSING_HOMES_INTAKE] (
    [ID]                           INT      DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_NURSING_HOMES_INTAKE]) NOT NULL,
    [DATE_OF_REPORT]               DATETIME NULL,
    [TOTAL_NEW_REPORTED_LOCATIONS] INT      NULL,
    [TOTAL_REPORTED_LOCATIONS]     INT      NULL,
    [TOTAL_REPORTED_NURSING_HOMES] INT      NULL,
    [DECEASED_NURSING_HOMES]       INT      NULL,
    [DATE_LAST_INSERTED]           DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_RIVM_NURSING_HOMES_INTAKE]
    ON [VWSINTER].[RIVM_NURSING_HOMES_INTAKE]([DATE_LAST_INSERTED] ASC);

