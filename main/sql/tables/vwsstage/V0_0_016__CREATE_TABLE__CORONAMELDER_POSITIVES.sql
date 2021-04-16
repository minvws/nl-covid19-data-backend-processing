-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSSTAGE_CORONAMELDER_POSITIVES]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSSTAGE_CORONAMELDER_POSITIVES
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSSTAGE.CORONAMELDER_POSITIVES(
  [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_CORONAMELDER_POSITIVES]),
  [Date (yyyy-mm-dd)] VARCHAR(100) NULL,
  [Reported positive tests through app authorised by GGD (daily)] VARCHAR(100) NULL,
  [Reported positive test through app authorised by GGD (cumulative)] VARCHAR(100) NULL,
  [DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
);


IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME='IX_CORONAMELDER_POSITIVES_STAGE')
    CREATE NONCLUSTERED INDEX IX_CORONAMELDER_POSITIVES_STAGE
    ON VWSSTAGE.CORONAMELDER_POSITIVES(DATE_LAST_INSERTED);
GO