-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSINTER_RIVM_IC_OPNAME]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSINTER_RIVM_IC_OPNAME
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSINTER.RIVM_IC_OPNAME(
    [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [DBO].[SEQ_VWSINTER_RIVM_IC_OPNAME]),
    [VERSION] VARCHAR(100) NULL,
	DATE_OF_REPORT DATETIME NULL,
    DATE_OF_STATISTICS DATETIME NULL,
    IC_ADMISSION_NOTIFICATION INT NULL,
    IC_ADMISSION INT NULL,
	[DATE_LAST_INSERTED] DATETIME DEFAULT GETDATE()
);

IF NOT EXISTS(SELECT * FROM sys.indexes WHERE NAME='IX_RIVM_IC_OPNAME_INTER')
    CREATE NONCLUSTERED INDEX IX_RIVM_IC_OPNAME_INTER
    ON VWSINTER.RIVM_IC_OPNAME(DATE_LAST_INSERTED)
    INCLUDE (DATE_OF_REPORT, DATE_OF_STATISTICS, IC_ADMISSION_NOTIFICATION, IC_ADMISSION);
GO