-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

ALTER TABLE VWSDEST.ESCALATIONLEVELS_PER_REGION
ALTER COLUMN POS_PER_100K_METING DECIMAL(16,2);
GO

ALTER TABLE VWSDEST.ESCALATIONLEVELS_PER_REGION
ALTER COLUMN ZKH_PER_1000K_METING DECIMAL(16,2);
GO

