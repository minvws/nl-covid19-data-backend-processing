-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_POSITIVE_TESTED_PEOPLE_INFECTED_DAILY_INCREASE_BASE]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_POSITIVE_TESTED_PEOPLE_INFECTED_DAILY_INCREASE_BASE
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE  VWSDEST.POSITIVE_TESTED_PEOPLE_INFECTED_DAILY_INCREASE_BASE
(
    [ID] [int] PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_POSITIVE_TESTED_PEOPLE_INFECTED_DAILY_INCREASE_BASE]),
    DATE_OF_REPORT DATETIME,
    NEW_DATE_OF_REPORT_UNIX BIGINT,
    GMCODE VARCHAR(20),
    OLD_DATE_OF_REPORT_UNIX BIGINT,
    OLD_VALUE DECIMAL(16,2),
    DIFFERENCE DECIMAL(16,2),
    DATE_LAST_INSERTED DATETIME DEFAULT GETDATE(),
    OLD_VALUE_PER_100K DECIMAL(16,2),
    DIFFERENCE_PER_100K DECIMAL(16,2)
)

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME='IX_POSITIVE_TESTED_PEOPLE_INFECTED_DAILY_INCREASE_BASE')
CREATE NONCLUSTERED INDEX IX_POSITIVE_TESTED_PEOPLE_INFECTED_DAILY_INCREASE_BASE
      ON VWSDEST.POSITIVE_TESTED_PEOPLE_INFECTED_DAILY_INCREASE_BASE (DATE_OF_REPORT, GMCODE)
      INCLUDE(NEW_DATE_OF_REPORT_UNIX, OLD_DATE_OF_REPORT_UNIX, OLD_VALUE, DIFFERENCE);
GO

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME='IX_POSITIVE_TESTED_PEOPLE_INFECTED_DAILY_INCREASE_BASE_100K')
CREATE NONCLUSTERED INDEX IX_POSITIVE_TESTED_PEOPLE_INFECTED_DAILY_INCREASE_BASE_100K
      ON VWSDEST.POSITIVE_TESTED_PEOPLE_INFECTED_DAILY_INCREASE_BASE (DATE_LAST_INSERTED, GMCODE)
      INCLUDE(NEW_DATE_OF_REPORT_UNIX, OLD_DATE_OF_REPORT_UNIX, OLD_VALUE_PER_100K, DIFFERENCE_PER_100K);
GO