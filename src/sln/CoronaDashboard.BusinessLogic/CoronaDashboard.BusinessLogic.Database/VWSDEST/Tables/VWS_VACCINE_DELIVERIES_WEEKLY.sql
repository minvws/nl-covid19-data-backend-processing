CREATE TABLE [VWSDEST].[VWS_VACCINE_DELIVERIES_WEEKLY] (
    [ID]                 INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_VACCINE_DELIVERIES_WEEKLY]) NOT NULL,
    [DATE_FIRST_DAY]     DATETIME      NULL,
    [DATE_OF_REPORT]     DATETIME      NULL,
    [DATE_START_UNIX]    BIGINT        NULL,
    [DATE_END_UNIX]      BIGINT        NULL,
    [VALUE_TYPE]         VARCHAR (100) NULL,
    [REPORT_STATUS]      VARCHAR (100) NULL,
    [AstraZeneca]        BIGINT        NULL,
    [BioNTech/Pfizer]    BIGINT        NULL,
    [CureVac]            BIGINT        NULL,
    [Janssen]            BIGINT        NULL,
    [Moderna]            BIGINT        NULL,
    [Sanofi]             BIGINT        NULL,
    [TOTAL_VALUE]        BIGINT        NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_VWS_VACCINE_DELIVERIES_WEEKLY]
    ON [VWSDEST].[VWS_VACCINE_DELIVERIES_WEEKLY]([DATE_LAST_INSERTED] ASC, [VALUE_TYPE] ASC, [REPORT_STATUS] ASC)
    INCLUDE([DATE_FIRST_DAY], [DATE_OF_REPORT], [DATE_START_UNIX], [DATE_END_UNIX], [AstraZeneca], [BioNTech/Pfizer], [CureVac], [Janssen], [Moderna], [Sanofi], [TOTAL_VALUE]);

