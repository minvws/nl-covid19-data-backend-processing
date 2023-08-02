CREATE TABLE [VWSSTATIC].[RIVM_COVID_19_CASE_NATIONAL] (
    [ID]                       INT           IDENTITY (1, 1) NOT NULL,
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
    [DATE_LAST_INSERTED]       DATETIME      DEFAULT (getdate()) NULL,
    [VERSION]                  VARCHAR (50)  NULL
);

