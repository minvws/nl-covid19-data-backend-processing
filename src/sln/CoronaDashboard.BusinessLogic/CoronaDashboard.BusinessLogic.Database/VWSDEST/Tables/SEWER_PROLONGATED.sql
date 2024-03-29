﻿CREATE TABLE [VWSDEST].[SEWER_PROLONGATED] (
    [ID]                                    INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_SEWER_PROLONGATED]) NOT NULL,
    [DATE_MEASUREMENT]                      DATETIME        NULL,
    [REGIO_CODE]                            VARCHAR (10)    NULL,
    [WEEK]                                  INT             NULL,
    [WEEK_UNIX]                             BIGINT          NULL,
    [AVERAGE_RNA_FLOW_PER_100000]           DECIMAL (16, 3) NULL,
    [REGION_COVERED_INHABITANTS]            INT             NULL,
    [DATE_LAST_INSERTED]                    DATETIME        DEFAULT (getdate()) NULL,
    [RNA_FLOW_PER_100000_PER_RWZI_ORIGINAL] FLOAT (53)      NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_DLI_DM_RC_SEWER_PROLONGATED]
    ON [VWSDEST].[SEWER_PROLONGATED]([DATE_LAST_INSERTED] ASC, [DATE_MEASUREMENT] ASC, [REGIO_CODE] ASC);


GO
CREATE NONCLUSTERED INDEX [NCI_VWSDEST_CIMS_VACCINATED_AGE_GROUP]
    ON [VWSDEST].[SEWER_PROLONGATED]([DATE_LAST_INSERTED] ASC, [DATE_MEASUREMENT] ASC, [REGIO_CODE] ASC)
    INCLUDE([AVERAGE_RNA_FLOW_PER_100000], [REGION_COVERED_INHABITANTS]);


GO
CREATE CLUSTERED INDEX [CI_DLI_VWSDEST_SEWER_PROLONGATED]
    ON [VWSDEST].[SEWER_PROLONGATED]([DATE_LAST_INSERTED] ASC);

