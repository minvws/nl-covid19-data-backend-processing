﻿CREATE TABLE [VWSSTAGE].[RIVM_NURSING_HOMES_INTAKE] (
    [ID]                           INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_RIVM_NURSING_HOMES_INTAKE]) NOT NULL,
    [DATE_OF_REPORT]               VARCHAR (100) NULL,
    [TOTAL_NEW_REPORTED_LOCATIONS] VARCHAR (100) NULL,
    [TOTAL_REPORTED_LOCATIONS]     VARCHAR (100) NULL,
    [TOTAL_REPORTED_NURSING_HOMES] VARCHAR (100) NULL,
    [DECEASED_NURSING_HOMES]       VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]           DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_RIVM_NURSING_HOMES_INTAKE]
    ON [VWSSTAGE].[RIVM_NURSING_HOMES_INTAKE]([DATE_LAST_INSERTED] ASC);

