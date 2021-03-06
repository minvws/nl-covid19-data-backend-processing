-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Production table for, serves as input for IntakeIntensiveCareMa part of the MessageProtocol
IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_INTENSIVE_CARE_ADMISSIONS]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_INTENSIVE_CARE_ADMISSIONS
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSDEST.INTENSIVE_CARE_ADMISSIONS(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_INTENSIVE_CARE_ADMISSIONS]),
	DATE_OF_REPORT DATETIME NULL,
	DATE_OF_REPORT_UNIX BIGINT NULL,
	MOVING_AVERAGE_IC DECIMAL(16, 1) NULL,
	TOTAL_COUNT INT NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
)