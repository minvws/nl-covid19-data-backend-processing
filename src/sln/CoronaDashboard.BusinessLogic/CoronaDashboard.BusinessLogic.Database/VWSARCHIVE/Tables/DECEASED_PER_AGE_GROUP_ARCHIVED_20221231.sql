﻿CREATE TABLE [VWSARCHIVE].[DECEASED_PER_AGE_GROUP_ARCHIVED_20221231] (
    [ID]                     INT             NOT NULL,
    [AGEGROUP]               VARCHAR (100)   NULL,
    [INHABITANTS_PERCENTAGE] DECIMAL (16, 1) NULL,
    [DEATHS]                 INT             NULL,
    [DEATHS_PERCENTAGE]      DECIMAL (16, 1) NULL,
    [DATE_LAST_INSERTED]     DATETIME        DEFAULT (getdate()) NULL
);

