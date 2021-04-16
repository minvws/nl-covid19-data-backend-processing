-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_RIVM_AGEGROUP_TOTALS]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_RIVM_AGEGROUP_TOTALS
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSDEST.RIVM_AGEGROUP_TOTALS(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_RIVM_AGEGROUP_TOTALS]),
	DATE_FILE DATETIME NULL,
	AGEGROUP VARCHAR(100) NULL,
	INFECTED INT NULL,
	DECEASED INT NULL,
	HOSPITALIZED INT NULL,
	INFECTED_TOTAL INT NULL,
	DECEASED_TOTAL INT NULL,
	HOSPITALIZED_TOTAL INT NULL,
	DATE_LAST_INSERTED DATETIME NULL DEFAULT (GETDATE())
);

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME='IX_RIVM_AGEGROUP_TOTALS')
    CREATE NONCLUSTERED INDEX IX_RIVM_AGEGROUP_TOTALS
    ON VWSDEST.RIVM_AGEGROUP_TOTALS(DATE_LAST_INSERTED,DATE_FILE,AGEGROUP)
    INCLUDE (INFECTED, DECEASED, HOSPITALIZED, INFECTED_TOTAL, DECEASED_TOTAL,HOSPITALIZED_TOTAL);
GO