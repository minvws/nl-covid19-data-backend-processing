﻿CREATE TABLE [VWSSTAGE].[VWS_VACCINE_DELIVERIES_ADMINISTERED] (
    [ID]                 INT           DEFAULT (NEXT VALUE FOR [DBO].[SEQ_VWSSTAGE_VACC_DELIVER_ADMIN]) NOT NULL,
    [DATE_OF_REPORT]     VARCHAR (100) NULL,
    [DATE_FIRST_DAY]     VARCHAR (100) NULL,
    [VALUE_TYPE]         VARCHAR (100) NULL,
    [VALUE_NAME]         VARCHAR (100) NULL,
    [REPORT_STATUS]      VARCHAR (100) NULL,
    [VALUE]              VARCHAR (100) NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VWS_VACCINE_DELIVERIES_ADMINISTERED_STAGE]
    ON [VWSSTAGE].[VWS_VACCINE_DELIVERIES_ADMINISTERED]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_OF_REPORT], [DATE_FIRST_DAY], [VALUE_TYPE], [VALUE_NAME], [REPORT_STATUS], [VALUE]);

