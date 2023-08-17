﻿CREATE TABLE [VWSSTAGE].[ECDC_VACCINATION_COVERAGES] (
    [ID]                    INT           IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED]    DATETIME      DEFAULT (getdate()) NULL,
    [YEAR_WEEK_ISO]         VARCHAR (100) NULL,
    [REPORTING_COUNTRY]     VARCHAR (100) NULL,
    [DENOMINATOR]           VARCHAR (100) NULL,
    [NUMBER_DOSES_RECEIVED] VARCHAR (100) NULL,
    [NUMBER_DOSES_EXPORTED] VARCHAR (100) NULL,
    [FIRST_DOSE]            VARCHAR (100) NULL,
    [FIRST_DOSE_REFUSED]    VARCHAR (100) NULL,
    [SECOND_DOSE]           VARCHAR (100) NULL,
    [DOSE_ADDITIONAL1]      VARCHAR (100) NULL,
    [UNKNOWN_DOSE]          VARCHAR (100) NULL,
    [REGION]                VARCHAR (100) NULL,
    [TARGET_GROUP]          VARCHAR (100) NULL,
    [VACCINE]               VARCHAR (100) NULL,
    [POPULATION]            VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

