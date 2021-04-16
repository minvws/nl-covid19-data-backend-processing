-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSSTATIC_RWZI_INHIBITANTS]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSSTATIC_RWZI_INHIBITANTS
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSSTATIC.RWZI_INHIBITANTS_2021(
    [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTATIC_RWZI_INHIBITANTS]),
    [CODE_RWZI] VARCHAR(100) NULL,
    [NAME_RWZI] VARCHAR(100) NULL,
    [INHABITANTS] INT NULL,
	[GEBIEDSCODE] VARCHAR(100) NULL,
    [PERCENTAGE] DECIMAL(12,2) NULL,
    [DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
);
