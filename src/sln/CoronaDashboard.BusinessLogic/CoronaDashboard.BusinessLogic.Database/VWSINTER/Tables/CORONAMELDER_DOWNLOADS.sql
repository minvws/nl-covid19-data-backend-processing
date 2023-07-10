CREATE TABLE [VWSINTER].[CORONAMELDER_DOWNLOADS] (
    [ID]                                             INT      DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_CORONAMELDER_DOWNLOADS]) NOT NULL,
    [Date (yyyy-mm-dd)]                              DATETIME NULL,
    [Downloads App Store (iOS) (daily)]              INT      NULL,
    [Downloads Play Store (Android) (daily)]         INT      NULL,
    [Downloads Huawei App Gallery (Android) (daily)] INT      NULL,
    [Total downloads (daily)]                        INT      NULL,
    [Total downloads (cumulative)]                   BIGINT   NULL,
    [DATE_LAST_INSERTED]                             DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_CORONAMELDER_DOWNLOADS_INTER]
    ON [VWSINTER].[CORONAMELDER_DOWNLOADS]([DATE_LAST_INSERTED] ASC);

