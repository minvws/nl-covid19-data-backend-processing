﻿CREATE TABLE [VWSSTAGE].[RIVM_COVID_19_CASE_NATIONAL] (
    [ID]                       INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_RIVM_COVID_19_CASE_NATIONAL]) NOT NULL,
    [DATE_FILE]                VARCHAR (100) NULL,
    [DATE_STATISTICS]          VARCHAR (100) NULL,
    [DATE_STATISTICS_TYPE]     VARCHAR (100) NULL,
    [AGEGROUP]                 VARCHAR (100) NULL,
    [SEX]                      VARCHAR (100) NULL,
    [PROVINCE]                 VARCHAR (100) NULL,
    [HOSPITAL_ADMISSION]       VARCHAR (100) NULL,
    [DECEASED]                 VARCHAR (100) NULL,
    [WEEK_OF_DEATH]            VARCHAR (100) NULL,
    [MUNICIPAL_HEALTH_SERVICE] VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]       DATETIME      DEFAULT (getdate()) NULL
);

