-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_CBS_INHABITANTS_PER_REGION]') AND type = 'SO')
CREATE SEQUENCE SEQ_CBS_INHABITANTS_PER_REGION
    START WITH 1
    INCREMENT BY 1;
GO

CREATE TABLE VWSSTATIC.CBS_INHABITANTS_PER_REGION(
    [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_CBS_INHABITANTS_PER_REGION]),
    [VRCODE] VARCHAR(5),
    [GMCODE] VARCHAR(10),
	[INHABITANTS] BIGINT,
	[DATE_LAST_INSERTED] DATETIME DEFAULT GETDATE()
);