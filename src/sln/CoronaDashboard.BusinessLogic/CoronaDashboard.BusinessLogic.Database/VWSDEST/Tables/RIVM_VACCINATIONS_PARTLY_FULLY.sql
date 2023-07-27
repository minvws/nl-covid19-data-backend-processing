CREATE TABLE [VWSDEST].[RIVM_VACCINATIONS_PARTLY_FULLY] (
    [ID]                            INT      DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_RIVM_VACCINATIONS_PARTLY_FULLY]) NOT NULL,
    [WEEK_START]                    DATETIME NULL,
    [WEEK_END]                      DATETIME NULL,
    [partially_vaccinated]          INT      NULL,
    [fully_vaccinated]              INT      NULL,
    [partially_or_fully_vaccinated] INT      NULL,
    [DATE_LAST_INSERTED]            DATETIME DEFAULT (getdate()) NULL,
    [booster1]                      INT      NULL,
    [booster1_increment]            INT      NULL,
    [DATE_OF_REPORT]                DATETIME NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_RIVM_VACCINATIONS_PARTLY_FULLY_DLI]
    ON [VWSDEST].[RIVM_VACCINATIONS_PARTLY_FULLY]([DATE_LAST_INSERTED] ASC)
    INCLUDE([WEEK_START]);

