CREATE TABLE [VWSDEST].[VWS_VACCINATION_AVAILABILITY] (
    [ID]                 INT        DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_VACCINATION_AVAILABILITY]) NOT NULL,
    [DATE_START]         DATE       NULL,
    [DATE_END]           DATE       NULL,
    [DATE_START_UNIX]    BIGINT     NULL,
    [DATE_END_UNIX]      BIGINT     NULL,
    [AstraZeneca]        FLOAT (53) NULL,
    [BioNTech/Pfizer]    FLOAT (53) NULL,
    [CureVac]            FLOAT (53) NULL,
    [Janssen]            FLOAT (53) NULL,
    [Moderna]            FLOAT (53) NULL,
    [Sanofi]             FLOAT (53) NULL,
    [DATE_LAST_INSERTED] DATETIME   DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VWS_VACCINATION_AVAILABILITY]
    ON [VWSDEST].[VWS_VACCINATION_AVAILABILITY]([DATE_LAST_INSERTED] ASC, [DATE_START] ASC, [DATE_END] ASC)
    INCLUDE([DATE_START_UNIX], [DATE_END_UNIX], [AstraZeneca], [BioNTech/Pfizer], [CureVac], [Janssen], [Moderna], [Sanofi]);

