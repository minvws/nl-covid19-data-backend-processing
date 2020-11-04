-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
-- Table for raw input of sewage measurements

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSSTAGE_RIVM_NURSING_HOMES_TOTALS]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSSTAGE_RIVM_NURSING_HOMES_TOTALS
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSSTAGE.RIVM_NURSING_HOMES_TOTALS(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_RIVM_NURSING_HOMES_TOTAlS]),
	MELDINGSDATUM VARCHAR(100) NULL,
  AANTAL VARCHAR(100) NULL,
	[DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
);