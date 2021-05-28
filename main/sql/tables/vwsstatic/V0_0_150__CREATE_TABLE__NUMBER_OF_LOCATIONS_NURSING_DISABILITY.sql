-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE TABLE VWSSTATIC.NUMBER_OF_LOCATIONS_NURSING_DISABILITY(
	VRCODE VARCHAR(50) NOT NULL,
	-- Since these numbers are always used during divisions for calculating percentages making it a float already will prevent int division behaviour.
	COUNT_LOC_NURSERY FLOAT NOT NULL,
	COUNT_LOC_DISABILITY FLOAT NOT NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
);