-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSSTATIC_CBS_DECEASED_PER_PERIOD]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSSTATIC_CBS_DECEASED_PER_PERIOD
    START WITH 1
    INCREMENT BY 1;
GO

CREATE TABLE VWSSTATIC.CBS_DECEASED_PER_PERIOD(
    [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTATIC_CBS_DECEASED_PER_PERIOD]),
    [PERIOD] VARCHAR(10),
    [WEEK_START] DATETIME,
    [DECEASED] BIGINT,
	[DATE_LAST_INSERTED] DATETIME DEFAULT GETDATE()
);