CREATE TABLE [VWSINTER].[CORONAMELDER_POSITIVES] (
    [ID]                                                                INT      DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_CORONAMELDER_POSITIVES]) NOT NULL,
    [Date (yyyy-mm-dd)]                                                 DATETIME NULL,
    [Reported positive tests through app authorised by GGD (daily)]     INT      NULL,
    [Reported positive test through app authorised by GGD (cumulative)] INT      NULL,
    [DATE_LAST_INSERTED]                                                DATETIME DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_CORONAMELDER_POSITIVES_INTER]
    ON [VWSINTER].[CORONAMELDER_POSITIVES]([DATE_LAST_INSERTED] ASC);

