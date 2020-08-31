-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Table for input of Foundation Nice data, inserted in the right data types

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSINTER_FOUNDATION_NICE_IC_INTAKE_COUNT]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSINTER_FOUNDATION_NICE_IC_INTAKE_COUNT
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSINTER.FOUNDATION_NICE_IC_INTAKE_COUNT(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_FOUNDATION_NICE_IC_INTAKE_COUNT]),
	DATE_OF_REPORT DATETIME NULL,
	[VALUE] INT NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
);

