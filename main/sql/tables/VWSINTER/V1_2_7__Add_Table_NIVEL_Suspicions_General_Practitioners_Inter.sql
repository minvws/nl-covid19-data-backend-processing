-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSINTER_NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSINTER_NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSINTER.NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS]),
	[WEEK] INT NULL,
	[INCIDENTIE_PER_100000] DECIMAL(16,2) NULL,
	[BOVENGRENS] INT NULL,
	[DIAGNOSE] VARCHAR(100) NULL,
	[JAAR] INT NULL,
	[GESCHAT_AANTAL] INT NULL,
	[ONDERGRENS] INT NULL,
	[DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
);