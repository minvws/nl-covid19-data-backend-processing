-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_NURSING_HOMES_PER_REGION]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_NURSING_HOMES_PER_REGION
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSDEST.NURSING_HOMES_PER_REGION(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [DBO].[SEQ_VWSDEST_NURSING_HOMES_PER_REGION]),
	DATE_OF_REPORT DATETIME NULL,
	DATE_OF_REPORT_UNIX BIGINT NULL,
	VRCODE VARCHAR(100) NULL,
	INFECTED_NURSERY_DAILY INT NULL,
	DECEASED_NURSERY_DAILY INT NULL,
	TOTAL_NEW_REPORTED_LOCATIONS INT NULL,
	TOTAL_REPORTED_LOCATIONS INT NULL,
	INFECTED_LOCATIONS_PERCENTAGE DECIMAL(16,2) NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE(), 
	[DATE_RANGE_START] DATETIME NULL ,
	[DATE_OF_REPORTS_LAG] DATETIME NULL ,
	DATE_RANGE_START_LAG DATETIME NULL , 
	[7D_AVERAGE_TOTAL_INFECTED] DECIMAL(16,2), 
	[7D_AVERAGE_TOTAL_INFECTED_LAG] DECIMAL(16,2), 
	[7D_AVERAGE_TOTAL_DECEASED] DECIMAL(16,2), 
	[7D_AVERAGE_TOTAL_DECEASED_LAG] DECIMAL(16,2)
 );