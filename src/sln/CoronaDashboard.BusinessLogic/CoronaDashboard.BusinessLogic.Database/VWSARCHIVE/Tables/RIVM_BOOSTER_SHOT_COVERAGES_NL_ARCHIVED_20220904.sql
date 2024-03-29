﻿CREATE TABLE [VWSARCHIVE].[RIVM_BOOSTER_SHOT_COVERAGES_NL_ARCHIVED_20220904] (
    [ID]                 BIGINT       IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME     DEFAULT (getdate()) NULL,
    [DATE_OF_STATISTICS] DATETIME     NULL,
    [DATE_OF_REPORT]     DATETIME     NULL,
    [AGE_GROUP]          VARCHAR (50) NULL,
    [BIRTH_YEAR]         VARCHAR (50) NULL,
    [PERCENTAGE]         FLOAT (53)   NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

