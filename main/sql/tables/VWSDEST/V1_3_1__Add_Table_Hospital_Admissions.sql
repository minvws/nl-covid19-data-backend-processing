-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Production table for national results of hospital admissions

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_HOSPITAL_ADMISSIONS]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_HOSPITAL_ADMISSIONS
  START WITH 1
  INCREMENT BY 1;
GO

 CREATE TABLE VWSDEST.HOSPITAL_ADMISSIONS(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_HOSPITAL_ADMISSIONS]),
	DATE_OF_REPORT DATETIME NULL,
	DATE_OF_REPORT_UNIX BIGINT NULL,
	TOTAL_COUNTS_PER_DAY INT NULL,
	MOVING_AVERAGE_HOSPITAL DECIMAL(16, 1) NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
 );

