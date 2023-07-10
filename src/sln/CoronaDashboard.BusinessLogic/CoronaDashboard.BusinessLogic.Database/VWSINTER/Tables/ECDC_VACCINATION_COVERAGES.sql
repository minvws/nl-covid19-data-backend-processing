CREATE TABLE [VWSINTER].[ECDC_VACCINATION_COVERAGES] (
    [ID]                    INT           IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED]    DATETIME      DEFAULT (getdate()) NULL,
    [YEAR_WEEK_ISO]         VARCHAR (100) NULL,
    [REPORTING_COUNTRY]     VARCHAR (100) NULL,
    [DENOMINATOR]           INT           NULL,
    [NUMBER_DOSES_RECEIVED] INT           NULL,
    [NUMBER_DOSES_EXPORTED] INT           NULL,
    [FIRST_DOSE]            INT           NULL,
    [FIRST_DOSE_REFUSED]    INT           NULL,
    [SECOND_DOSE]           INT           NULL,
    [DOSE_ADDITIONAL1]      INT           NULL,
    [UNKNOWN_DOSE]          INT           NULL,
    [REGION]                VARCHAR (100) NULL,
    [TARGET_GROUP]          VARCHAR (100) NULL,
    [VACCINE]               VARCHAR (100) NULL,
    [POPULATION]            INT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

