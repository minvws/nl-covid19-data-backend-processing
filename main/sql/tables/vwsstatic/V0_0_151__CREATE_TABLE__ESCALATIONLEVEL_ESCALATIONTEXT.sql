-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE TABLE VWSSTATIC.ESCALATIONLEVEL_ESCALATIONTEXT(
    [ESCALATION_LEVEL] [INT] NOT NULL,
	[ESCALATION_TEXT] [VARCHAR](50) NOT NULL,
    DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
);