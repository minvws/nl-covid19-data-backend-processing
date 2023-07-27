﻿CREATE TABLE [VWSARCHIVE].[NURSING_HOMES_PER_REGION_ARCHIVED_20230126] (
    [ID]                            INT             NOT NULL,
    [DATE_OF_REPORT]                DATETIME        NULL,
    [DATE_OF_REPORT_UNIX]           BIGINT          NULL,
    [VRCODE]                        VARCHAR (100)   NULL,
    [INFECTED_NURSERY_DAILY]        INT             NULL,
    [DECEASED_NURSERY_DAILY]        INT             NULL,
    [TOTAL_NEW_REPORTED_LOCATIONS]  INT             NULL,
    [TOTAL_REPORTED_LOCATIONS]      INT             NULL,
    [INFECTED_LOCATIONS_PERCENTAGE] DECIMAL (16, 2) NULL,
    [DATE_LAST_INSERTED]            DATETIME        DEFAULT (getdate()) NULL,
    [DATE_RANGE_START]              DATETIME        NULL,
    [DATE_OF_REPORTS_LAG]           DATETIME        NULL,
    [DATE_RANGE_START_LAG]          DATETIME        NULL,
    [7D_AVERAGE_TOTAL_INFECTED]     DECIMAL (16, 2) NULL,
    [7D_AVERAGE_TOTAL_INFECTED_LAG] DECIMAL (16, 2) NULL,
    [7D_AVERAGE_TOTAL_DECEASED]     DECIMAL (16, 2) NULL,
    [7D_AVERAGE_TOTAL_DECEASED_LAG] DECIMAL (16, 2) NULL
);

