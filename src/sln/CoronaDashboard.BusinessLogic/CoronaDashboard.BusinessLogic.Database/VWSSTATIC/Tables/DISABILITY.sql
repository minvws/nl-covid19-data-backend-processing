CREATE TABLE [VWSSTATIC].[DISABILITY] (
    [ID]                                    INT           IDENTITY (1, 1) NOT NULL,
    [DATE_OF_REPORT]                        VARCHAR (100) NULL,
    [DATE_OF_STATISTIC_REPORTED]            VARCHAR (100) NULL,
    [SECURITY_REGION_CODE]                  VARCHAR (100) NULL,
    [SECURITY_REGION_NAME]                  VARCHAR (100) NULL,
    [TOTAL_CASES_REPORTED]                  VARCHAR (100) NULL,
    [TOTAL_DECEASED_REPORTED]               VARCHAR (100) NULL,
    [TOTAL_NEW_INFECTED_LOCATIONS_REPORTED] VARCHAR (100) NULL,
    [TOTAL_INFECTED_LOCATIONS_REPORTED]     VARCHAR (100) NULL,
    [Date_Last_Inserted]                    DATETIME      DEFAULT (getdate()) NULL
);

