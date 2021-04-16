-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSINTER_CBS_DECEASED_PER_WEEK]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSINTER_CBS_DECEASED_PER_WEEK
    START WITH 1
    INCREMENT BY 1;
GO

CREATE TABLE VWSINTER.CBS_DECEASED_PER_WEEK(
    [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_CBS_DECEASED_PER_WEEK])
,   [YEAR] INT NULL
,   [WEEK] INT NULL
,   [DECEASED_ACTUAL] INT
,   [DATE_LAST_INSERTED] DATETIME DEFAULT GETDATE()
);