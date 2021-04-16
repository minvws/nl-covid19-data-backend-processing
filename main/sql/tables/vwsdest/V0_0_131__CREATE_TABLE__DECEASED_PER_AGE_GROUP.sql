-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_SP_DECEASED_PER_AGE_GROUP]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_SP_DECEASED_PER_AGE_GROUP
  START WITH 1
  INCREMENT BY 1;
GO

 CREATE TABLE VWSDEST.DECEASED_PER_AGE_GROUP(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_SP_DECEASED_PER_AGE_GROUP]),

    AGEGROUP VARCHAR(100) NULL,
    INHABITANTS_PERCENTAGE DECIMAL(16,1) NULL,
    DEATHS INT NULL,
    DEATHS_PERCENTAGE DECIMAL(16,1) NULL,
    DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
 );
 
CREATE NONCLUSTERED INDEX IX_DECEASED_PER_AGE_GROUP
ON VWSDEST.DECEASED_PER_AGE_GROUP([DATE_LAST_INSERTED])
INCLUDE (
    AGEGROUP ,
    INHABITANTS_PERCENTAGE ,
    DEATHS ,
    DEATHS_PERCENTAGE 
);