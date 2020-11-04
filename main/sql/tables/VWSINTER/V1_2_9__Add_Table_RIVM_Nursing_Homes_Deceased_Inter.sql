-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
-- Table for raw input of sewage measurements

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSINTER_RIVM_NURSING_HOMES_DECEASED]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSINTER_RIVM_NURSING_HOMES_DECEASED
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSINTER.RIVM_NURSING_HOMES_DECEASED(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_NURSING_HOMES_DECEASED]),
	DATUM_VAN_OVERLIJDEN DATETIME,
  AANTAL INTEGER,
	[DATE_LAST_INSERTED] DATETIME DEFAULT GETDATE()
);