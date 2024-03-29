﻿CREATE TABLE [VWSARCHIVE].[RIVM_COVID_19_NUMBER_MUNICIPALITY_ARCHIVE_STAGE] (
    [ID]                       INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSARCHIVE_COVID19_MUNICIPALITY_ARCHIVE_STAGE2]) NOT NULL,
    [DATE_OF_REPORT]           VARCHAR (100) NULL,
    [DATE_OF_PUBLICATION]      VARCHAR (100) NULL,
    [MUNICIPALITY_CODE]        VARCHAR (100) NULL,
    [MUNICIPALITY_NAME]        VARCHAR (100) NULL,
    [PROVINCE]                 VARCHAR (100) NULL,
    [SECURITY_REGION_CODE]     VARCHAR (100) NULL,
    [SECURITY_REGION_NAME]     VARCHAR (100) NULL,
    [MUNICIPAL_HEALTH_SERVICE] VARCHAR (100) NULL,
    [ROAZ_REGION]              VARCHAR (100) NULL,
    [TOTAL_REPORTED]           VARCHAR (100) NULL,
    [HOSPITAL_ADMISSION]       VARCHAR (100) NULL,
    [DECEASED]                 VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]       DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_DLI_RIVM_COVID_19_NUMBER_MUNICIPALITY_ARCHIVE_STAGE]
    ON [VWSARCHIVE].[RIVM_COVID_19_NUMBER_MUNICIPALITY_ARCHIVE_STAGE]([DATE_LAST_INSERTED] ASC);

