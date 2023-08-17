﻿CREATE TABLE [VWSINTER].[RIVM_NURSING_HOMES_TOTALS] (
    [ID]                 INT      DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_NURSING_HOMES_TOTAlS]) NOT NULL,
    [MELDINGSDATUM]      DATETIME NULL,
    [AANTAL]             INT      NULL,
    [DATE_LAST_INSERTED] DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_RIVM_NURSING_HOMES_TOTALS_MD]
    ON [VWSINTER].[RIVM_NURSING_HOMES_TOTALS]([MELDINGSDATUM] ASC)
    INCLUDE([AANTAL], [DATE_LAST_INSERTED]);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_RIVM_NURSING_HOMES_TOTALS]
    ON [VWSINTER].[RIVM_NURSING_HOMES_TOTALS]([DATE_LAST_INSERTED] ASC, [MELDINGSDATUM] ASC);

