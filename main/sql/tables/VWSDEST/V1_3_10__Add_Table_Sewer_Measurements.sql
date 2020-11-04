-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Production table for results of sewage measurements.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_SEWER_MEASUREMENTS]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_SEWER_MEASUREMENTS
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSDEST.SEWER_MEASUREMENTS(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_SEWER_MEASUREMENTS]),
	[WEEK] INT NULL,
	[WEEK_UNIX] BIGINT,
	[AVERAGE] DECIMAL(16,2) NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
)