CREATE TABLE [VWSDEST].[ECDC_VARIANTS] (
    [ID]                    INT            DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_ECDC_VARIANTS]) NOT NULL,
    [COUNTRY]               VARCHAR (100)  NULL,
    [COUNTRY_CODE]          VARCHAR (3)    NULL,
    [YEAR_WEEK]             VARCHAR (100)  NULL,
    [WEEK_START]            DATE           NULL,
    [WEEK_END]              DATE           NULL,
    [SOURCE]                VARCHAR (100)  NULL,
    [NEW_CASES]             INT            NULL,
    [SAMPLE_SIZE]           INT            NULL,
    [ECDC_CATEGORY]         VARCHAR (100)  NULL,
    [PERCENT_CASES_SAMPLED] DECIMAL (8, 1) NULL,
    [VARIANT_CODE]          VARCHAR (2048) NULL,
    [VARIANT]               VARCHAR (100)  NULL,
    [VARIANT_OF_CONCERN]    BIT            NULL,
    [OCCURRENCE]            INT            NULL,
    [PERCENT_VARIANT]       DECIMAL (8, 1) NULL,
    [DATE_LAST_INSERTED]    DATETIME       DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_ECDC_VARIANTS]
    ON [VWSDEST].[ECDC_VARIANTS]([DATE_LAST_INSERTED] ASC);

