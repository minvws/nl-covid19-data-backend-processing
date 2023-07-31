CREATE TABLE [VWSARCHIVE].[ELDERLY_AT_HOME_VR_ARCHIVED_20230126] (
    [ID]                                            INT             NOT NULL,
    [DATE_OF_REPORT]                                DATETIME        NULL,
    [DATE_OF_REPORT_UNIX]                           BIGINT          NULL,
    [VRCODE]                                        VARCHAR (100)   NULL,
    [INFECTED_ELDERLY_AT_HOME_DAILY]                INT             NULL,
    [INFECTED_ELDERLY_AT_HOME_DAILY_PER_100K]       FLOAT (53)      NULL,
    [DECEASED_ELDERLY_AT_HOME_DAILY]                INT             NULL,
    [DATE_LAST_INSERTED]                            DATETIME        DEFAULT (getdate()) NULL,
    [DATE_RANGE_START]                              DATETIME        NULL,
    [DATE_OF_REPORTS_LAG]                           DATETIME        NULL,
    [DATE_RANGE_START_LAG]                          DATETIME        NULL,
    [7D_AVERAGE_INFECTED_ELDERLY_AT_HOME_DAILY]     DECIMAL (16, 2) NULL,
    [7D_AVERAGE_INFECTED_ELDERLY_AT_HOME_DAILY_LAG] DECIMAL (16, 2) NULL,
    [7D_AVERAGE_DECEASED_ELDERLY_AT_HOME_DAILY]     DECIMAL (16, 2) NULL,
    [7D_AVERAGE_DECEASED_ELDERLY_AT_HOME_DAILY_LAG] DECIMAL (16, 2) NULL
);

