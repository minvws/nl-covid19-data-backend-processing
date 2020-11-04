-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Column renaming is not recommended. Archive the current table by renaming to '%_OLD'. Drop current table, before recreating with newly named columns.
EXEC sp_rename 'VWSINTER.RIVM_NURSING_HOMES_INFECTED_LOCATIONS', 'RIVM_NURSING_HOMES_INFECTED_LOCATIONS_OLD';
GO

CREATE TABLE VWSINTER.RIVM_NURSING_HOMES_INFECTED_LOCATIONS(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_NURSING_HOMES_INFECTED_LOCATIONS]),
  [PUBLICATIEDATUMRIVM] DATETIME NULL,
  [AANTAL_NIEUW_BESMETTE_VERPLEEGHUIS_LOCATIES] INT NULL,
  [AANTAL_NIEUW_BESMETTINGSVRIJE_VERPLEEGHUIS_LOCATIES] INT NULL,
  [AANTAL_BESMETTE_VERPLEEGHUIS_LOCATIES] INT NULL,
	[DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
);