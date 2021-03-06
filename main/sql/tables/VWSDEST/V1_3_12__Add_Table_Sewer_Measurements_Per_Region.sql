-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Production table for results of sewage measurements per region.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_SEWER_MEASUREMENTS_PER_REGION]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_SEWER_MEASUREMENTS_PER_REGION
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSDEST.SEWER_MEASUREMENTS_PER_REGION (
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_SEWER_MEASUREMENTS_PER_REGION]),
	[WEEK] INT NULL,
	[WEEK_UNIX] BIGINT,
	VRCODE VARCHAR(100),
	AVERAGE DECIMAL(16,2),
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
)