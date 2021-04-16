-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSINTER_CORONAMELDER_DOWNLOADS]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSINTER_CORONAMELDER_DOWNLOADS
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSINTER.CORONAMELDER_DOWNLOADS(
  [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_CORONAMELDER_DOWNLOADS]),
  [Date (yyyy-mm-dd)] DATETIME NULL,
  [Downloads App Store (iOS) (daily)] INT NULL,
  [Downloads Play Store (Android) (daily)] INT NULL,
  [Downloads Huawei App Gallery (Android) (daily)] INT NULL,
  [Total downloads (daily)] INT NULL,
  [Total downloads (cumulative)] BIGINT NULL,
  [DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
);


IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME='IX_CORONAMELDER_DOWNLOADS_INTER')
    CREATE NONCLUSTERED INDEX IX_CORONAMELDER_DOWNLOADS_INTER
    ON VWSINTER.CORONAMELDER_DOWNLOADS(DATE_LAST_INSERTED);
GO