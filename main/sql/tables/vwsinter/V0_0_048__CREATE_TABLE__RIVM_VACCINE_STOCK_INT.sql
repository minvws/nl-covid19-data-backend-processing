-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSINTER_RIVM_VACCINE_STOCK]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSINTER_RIVM_VACCINE_STOCK
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSINTER.RIVM_VACCINE_STOCK(
  [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_VACCINE_STOCK]),
  [DATE_OF_STATISTICS] date NULL,
  [VACCINE_NAME] varchar(50) NULL,
  [TOTAL_STOCK] int NULL,
  [DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE(),
  FREE_STOCK INT NULL,
  DATE_OF_REPORT DATETIME NULL
);

