CREATE TABLE [VWSARCHIVE].[RIVM_DECEASED_DAILY_PER_MUNICIPALITY_ARCHIVED_20221231] (
    [ID]                      INT             NOT NULL,
    [DATE_OF_REPORT]          DATETIME        NULL,
    [DATE_OF_REPORT_UNIX]     BIGINT          NULL,
    [MUNICIPALITY_CODE]       VARCHAR (10)    NULL,
    [OLD_DATE_OF_REPORT]      DATETIME        NULL,
    [OLD_DATE_OF_REPORT_UNIX] BIGINT          NULL,
    [OLD_VALUE]               INT             NULL,
    [DIFFERENCE]              INT             NULL,
    [DECEASED_ACTUAL]         INT             NULL,
    [DECEASED_CUMULATIVE]     INT             NULL,
    [DATE_LAST_INSERTED]      DATETIME        DEFAULT (getdate()) NULL,
    [WEEK_START]              DATETIME        NULL,
    [DECEASED_7D_AVG]         DECIMAL (16, 2) NULL,
    [WEEK_START_LAG]          DATETIME        NULL,
    [DECEASED_7D_AVG_LAG]     DECIMAL (16, 2) NULL
);

