CREATE TABLE [VWSDEST].[RIVM_SITUATIONS] (
    [ID]                          INT            DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_RIVM_SITUATIONS]) NOT NULL,
    [VRCODE]                      VARCHAR (10)   NULL,
    [DATE_START]                  DATETIME       NULL,
    [DATE_END]                    DATETIME       NULL,
    [has_sufficient_data]         VARCHAR (10)   NULL,
    [situations_known_percentage] DECIMAL (5, 1) NULL,
    [situations_known_total]      INT            NULL,
    [investigations_total]        INT            NULL,
    [home_and_visits]             DECIMAL (5, 1) NULL,
    [work]                        DECIMAL (5, 1) NULL,
    [school_and_day_care]         DECIMAL (5, 1) NULL,
    [health_care]                 DECIMAL (5, 1) NULL,
    [gathering]                   DECIMAL (5, 1) NULL,
    [travel]                      DECIMAL (5, 1) NULL,
    [hospitality]                 DECIMAL (5, 1) NULL,
    [other]                       DECIMAL (5, 1) NULL,
    [DATE_LAST_INSERTED]          DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_RIVM_SITUATIONS_VRCODE_DATE_LAST_INSERTED]
    ON [VWSDEST].[RIVM_SITUATIONS]([VRCODE] ASC, [DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_START], [DATE_END], [has_sufficient_data], [situations_known_percentage], [situations_known_total], [investigations_total], [home_and_visits], [work], [school_and_day_care], [health_care], [gathering], [travel], [hospitality], [other]);


GO
CREATE NONCLUSTERED INDEX [IX_RIVM_SITUATIONS_VRCODE]
    ON [VWSDEST].[RIVM_SITUATIONS]([VRCODE] ASC)
    INCLUDE([DATE_START], [DATE_END], [has_sufficient_data], [situations_known_percentage], [situations_known_total], [investigations_total], [home_and_visits], [work], [school_and_day_care], [health_care], [gathering], [travel], [hospitality], [other], [DATE_LAST_INSERTED]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_RIVM_SITUATIONS_DLI]
    ON [VWSDEST].[RIVM_SITUATIONS]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_START]);

