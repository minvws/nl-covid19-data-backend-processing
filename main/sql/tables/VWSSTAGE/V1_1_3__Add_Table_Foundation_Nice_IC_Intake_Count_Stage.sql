-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
-- Table for raw input of Foundation Nice data

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSSTAGE_FOUNDATION_NICE_IC_INTAKE_COUNT]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSSTAGE_FOUNDATION_NICE_IC_INTAKE_COUNT
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSSTAGE.FOUNDATION_NICE_IC_INTAKE_COUNT
(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_FOUNDATION_NICE_IC_INTAKE_COUNT]),
	[DATE] VARCHAR(100) NULL,
	[VALUE] VARCHAR(100) NULL,
	[BATCH_ID] INT NULL,
	[DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
);