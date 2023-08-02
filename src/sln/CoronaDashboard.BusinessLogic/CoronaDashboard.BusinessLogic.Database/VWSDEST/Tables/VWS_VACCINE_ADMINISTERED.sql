CREATE TABLE [VWSDEST].[VWS_VACCINE_ADMINISTERED] (
    [ID]                 INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_VACCINE_ADMINISTERED]) NOT NULL,
    [DATE_FIRST_DAY]     DATETIME      NULL,
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
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    [Novavax]            BIGINT        NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_VWS_VACCINE_ADMINISTERED_2]
    ON [VWSDEST].[VWS_VACCINE_ADMINISTERED]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_FIRST_DAY], [DATE_START_UNIX], [DATE_END_UNIX], [VALUE_TYPE], [REPORT_STATUS], [AstraZeneca], [BioNTech/Pfizer], [CureVac], [Janssen], [Moderna], [Sanofi], [Novavax]);

