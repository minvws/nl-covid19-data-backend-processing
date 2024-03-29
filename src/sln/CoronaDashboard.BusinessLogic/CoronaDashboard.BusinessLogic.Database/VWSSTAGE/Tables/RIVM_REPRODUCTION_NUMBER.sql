﻿CREATE TABLE [VWSSTAGE].[RIVM_REPRODUCTION_NUMBER] (
    [ID]                 INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_RIVM_REPRODUCTION_NUMBER]) NOT NULL,
    [DATE]               VARCHAR (100) NULL,
    [RT_LOW]             VARCHAR (100) NULL,
    [RT_AVG]             VARCHAR (100) NULL,
    [RT_UP]              VARCHAR (100) NULL,
    [POPULATION]         VARCHAR (100) NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    [VERSION]            VARCHAR (20)  NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_RIVM_REPRODUCTION_NUMBER]
    ON [VWSSTAGE].[RIVM_REPRODUCTION_NUMBER]([DATE_LAST_INSERTED] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_RIVM_REPRODUCTION_NUMBER_DLI]
    ON [VWSSTAGE].[RIVM_REPRODUCTION_NUMBER]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE], [RT_LOW], [RT_AVG], [RT_UP]);

