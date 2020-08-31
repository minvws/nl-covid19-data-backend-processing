-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSSTATIC_RWZI_AWZI]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSSTATIC_RWZI_AWZI
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSSTATIC.RWZI_AWZI(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTATIC_RWZI_AWZI]),
	RWZI_AWZI_code VARCHAR(100) NULL,
	RWZI_AWZI_name VARCHAR(100) NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
);