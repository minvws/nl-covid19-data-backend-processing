CREATE TABLE [VWSBITEMPORAL].[POSITIVE_TESTED_PEOPLE_PER_MUNICIPALITY] (
    [ID]                                          INT             IDENTITY (1, 1) NOT NULL,
    [DATE_OF_REPORT]                              DATETIME        NULL,
    [DATE_OF_REPORT_UNIX]                         BIGINT          NULL,
    [MUNICIPALITY_CODE]                           VARCHAR (100)   NULL,
    [MUNICIPALITY_NAME]                           VARCHAR (200)   NULL,
    [INFECTED_DAILY_TOTAL]                        INT             NULL,
    [INFECTED_DAILY_INCREASE]                     DECIMAL (16, 1) NULL,
    [DATE_RANGE_START]                            DATETIME        NULL,
    [DATE_OF_REPORTS_LAG]                         DATETIME        NULL,
    [DATE_RANGE_START_LAG]                        DATETIME        NULL,
    [7D_AVERAGE_INFECTED_DAILY_INCREASE_TOTAL]    DECIMAL (16, 2) NULL,
    [7D_AVERAGE_INFECTED_DAILY_INCREASE_LAG]      DECIMAL (16, 2) NULL,
    [7D_AVERAGE_INFECTED_DAILY_INCREASE_ABSOLUTE] DECIMAL (16, 2) NULL,
    [DATE_INSERTED]                               DATETIME        NULL,
    [START_DATE]                                  DATETIME        NOT NULL,
    [END_DATE]                                    DATETIME        DEFAULT (CONVERT([datetime],'31-12-9999',(105))) NOT NULL
);

