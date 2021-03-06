-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSSTATIC_SAFETY_REGIONS_PER_MUNICIPAL]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSSTATIC_SAFETY_REGIONS_PER_MUNICIPAL
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSSTATIC.SAFETY_REGIONS_PER_MUNICIPAL(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTATIC_SAFETY_REGIONS_PER_MUNICIPAL]),
	GMCODE VARCHAR(100) NULL,
	GMNAAM VARCHAR(100) NULL,
	VRCODE VARCHAR(100) NULL,
	VRNAAM VARCHAR(100) NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
);

CREATE NONCLUSTERED INDEX IX_SAFETY_REGIONS_PER_MUNICIPAL
ON VWSSTATIC.SAFETY_REGIONS_PER_MUNICIPAL(GMCODE);