﻿CREATE TABLE [VWSSTATIC].[NICE_HOSPITAL] (
    [ID]                              INT           IDENTITY (1, 1) NOT NULL,
    [VERSION]                         VARCHAR (100) NULL,
    [DATE_OF_REPORT]                  VARCHAR (100) NULL,
    [DATE_OF_STATISTICS]              VARCHAR (100) NULL,
    [MUNICIPALITY_CODE]               VARCHAR (100) NULL,
    [MUNICIPALITY_NAME]               VARCHAR (100) NULL,
    [SECURITY_REGION_CODE]            VARCHAR (100) NULL,
    [SECURITY_REGION_NAME]            VARCHAR (100) NULL,
    [HOSPITAL_ADMISSION_NOTIFICATION] VARCHAR (100) NULL,
    [HOSPITAL_ADMISSION]              VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]              DATETIME      DEFAULT (getdate()) NULL
);

