-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_BEHAVIOR_VACCINE_WILLINGNESS]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_BEHAVIOR_VACCINE_WILLINGNESS
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSDEST.BEHAVIOR_VACCINE_WILLINGNESS
(
    [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_BEHAVIOR_VACCINE_WILLINGNESS]),
    DATE_OF_MEASUREMENT DATETIME NULL,
    DATE_START_UNIX BIGINT NULL,
    DATE_END_UNIX BIGINT NULL, 
    WAVE INT NULL,
		VACCINE_WILLINGNESS NUMERIC(10,2),
    VACCINATED NUMERIC(10,2),
    [DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
);


CREATE NONCLUSTERED INDEX IX_DEST_BEHAVIOR_VACCINE_WILLINGNESS
ON VWSDEST.BEHAVIOR_VACCINE_WILLINGNESS (DATE_LAST_INSERTED, DATE_OF_MEASUREMENT)
INCLUDE (DATE_START_UNIX, DATE_END_UNIX, WAVE, VACCINE_WILLINGNESS, VACCINATED);
