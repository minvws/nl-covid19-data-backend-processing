﻿CREATE TABLE [VWSSTAGE].[RIVM_NURSING_HOMES_COMBINED] (
    [ID]                                    INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_RIVM_NURSING_HOMES_COMBINED]) NOT NULL,
    [DATE_OF_REPORT]                        VARCHAR (100) NULL,
    [DATE_OF_STATISTIC_REPORTED]            VARCHAR (100) NULL,
    [SECURITY_REGION_CODE]                  VARCHAR (100) NULL,
    [SECURITY_REGION_NAME]                  VARCHAR (100) NULL,
    [TOTAL_CASES_REPORTED]                  VARCHAR (100) NULL,
    [TOTAL_DECEASED_REPORTED]               VARCHAR (100) NULL,
    [TOTAL_NEW_INFECTED_LOCATIONS_REPORTED] VARCHAR (100) NULL,
    [TOTAL_INFECTED_LOCATIONS_REPORTED]     VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]                    DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_STAGE_RIVM_NURSING_HOMES_COMBINED_DLI]
    ON [VWSSTAGE].[RIVM_NURSING_HOMES_COMBINED]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_OF_REPORT], [DATE_OF_STATISTIC_REPORTED], [SECURITY_REGION_CODE], [SECURITY_REGION_NAME], [TOTAL_CASES_REPORTED], [TOTAL_DECEASED_REPORTED], [TOTAL_NEW_INFECTED_LOCATIONS_REPORTED], [TOTAL_INFECTED_LOCATIONS_REPORTED]);


GO
CREATE NONCLUSTERED INDEX [IX_RIVM_NURSING_HOMES_COMBINED_STAGE]
    ON [VWSSTAGE].[RIVM_NURSING_HOMES_COMBINED]([DATE_LAST_INSERTED] ASC);

