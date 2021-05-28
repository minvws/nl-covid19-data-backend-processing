-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE TABLE VWSSTATIC.INHABITANTS_PER_MUNICIPALITY(
    [REGIO] [VARCHAR](50) NOT NULL,
	[GMCODE] [VARCHAR](50) NOT NULL,
	[VRCODE] [VARCHAR](50) NOT NULL,
	[VRNAME] [VARCHAR](50) NOT NULL,
	[INHABITANTS] [int] NOT NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
);