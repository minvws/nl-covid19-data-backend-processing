﻿CREATE TABLE [VWSSTAGE].[INHABITANTS_PER_MUNICIPALITY] (
    [ID]                 INT          IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME     DEFAULT (getdate()) NOT NULL,
    [REGION]             VARCHAR (50) NOT NULL,
    [GM_CODE]            VARCHAR (50) NOT NULL,
    [VR_CODE]            VARCHAR (50) NOT NULL,
    [VR_NAME]            VARCHAR (50) NOT NULL,
    [INHABITANTS]        VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

