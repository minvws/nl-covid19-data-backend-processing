﻿CREATE TABLE [VWSSTATIC].[RECLASSIFIED_MUNICIPALITY_MAPPING] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME        DEFAULT (getdate()) NOT NULL,
    [GM_CODE_ORIGINAL]   NVARCHAR (10)   NULL,
    [GM_NAME_ORIGINAL]   NVARCHAR (255)  NULL,
    [GM_CODE_NEW]        NVARCHAR (10)   NULL,
    [GM_NAME_NEW]        NVARCHAR (255)  NULL,
    [VR_CODE]            NVARCHAR (10)   NULL,
    [VR_NAME]            NVARCHAR (255)  NULL,
    [PROVINCE_CODE]      NVARCHAR (10)   NULL,
    [PROVINCE_NAME]      NVARCHAR (255)  NULL,
    [GGD_CODE]           NVARCHAR (10)   NULL,
    [GGD_NAME]           NVARCHAR (255)  NULL,
    [SHARES]             DECIMAL (16, 6) NOT NULL,
    [ACTIVE]             INT             DEFAULT ((0)) NOT NULL
);

