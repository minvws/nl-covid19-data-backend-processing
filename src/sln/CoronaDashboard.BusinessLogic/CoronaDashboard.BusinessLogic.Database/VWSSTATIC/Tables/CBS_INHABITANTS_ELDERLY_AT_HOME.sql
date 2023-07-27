CREATE TABLE [VWSSTATIC].[CBS_INHABITANTS_ELDERLY_AT_HOME] (
    [ID]                                                        INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTATIC_CBS_INHABITANTS_ELDERLY_AT_HOME]) NOT NULL,
    [NAAM VEILIGHEIDSREGIO]                                     VARCHAR (100) NULL,
    [CODE VEILIGHEIDSREGIO]                                     VARCHAR (100) NULL,
    [PERSONEN VAN 70 JAAR OF OUDER IN PARTICULIERE HUISHOUDENS] INT           NULL,
    [DATE_LAST_INSERTED]                                        DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

