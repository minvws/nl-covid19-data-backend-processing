-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSSTAGE_DISABILITY]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSSTAGE_DISABILITY
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSSTAGE.DISABILITY(
  [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_DISABILITY]),
  [DATE_OF_REPORT] VARCHAR(100) NULL,
  [DATE_OF_STATISTIC_REPORTED] VARCHAR(100) NULL,
  [SECURITY_REGION_CODE] VARCHAR(100) NULL,
  [SECURITY_REGION_NAME] VARCHAR(100) NULL,
  [TOTAL_CASES_REPORTED]VARCHAR(100) NULL,
  [TOTAL_DECEASED_REPORTED] VARCHAR(100) NULL,
  [TOTAL_NEW_INFECTED_LOCATIONS_REPORTED] VARCHAR(100) NULL,
  [TOTAL_INFECTED_LOCATIONS_REPORTED] VARCHAR(100) NULL,
  [DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
);