-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE TABLE VWSSTATIC.NURSING_HOME_LOCATIONS_PER_REGION(
	VRCODE VARCHAR(50) NOT NULL,
	VRNAAM VARCHAR(100) NOT NULL,
	-- Since these numbers are always used during divisions for calculating percentages making it a float already will prevent int division behaviour.
	VERPLEEGHUIZEN FLOAT NOT NULL,
	GEHANDICAPTENZORGINSTELLINGEN FLOAT NOT NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
);