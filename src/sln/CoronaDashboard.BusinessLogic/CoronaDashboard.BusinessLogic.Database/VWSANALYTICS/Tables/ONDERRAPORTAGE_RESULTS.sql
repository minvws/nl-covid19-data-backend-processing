CREATE TABLE [VWSANALYTICS].[ONDERRAPORTAGE_RESULTS] (
    [load_moment]             NVARCHAR (MAX) NULL,
    [std]                     FLOAT (53)     NULL,
    [mean]                    FLOAT (53)     NULL,
    [start_load_times]        NVARCHAR (MAX) NULL,
    [end_load_times]          NVARCHAR (MAX) NULL,
    [time_range_days_rounded] BIGINT         NULL,
    [TARGET_TABLE]            NVARCHAR (MAX) NULL,
    [COL_VALUE]               NVARCHAR (MAX) NULL,
    [DATE_LAST_INSERTED]      DATETIME       NULL
);

