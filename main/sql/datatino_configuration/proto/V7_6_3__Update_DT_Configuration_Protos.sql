-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertProtoConfiguration] 'NL', 'infectious_people_last_known_average', 'VWSDEST.V_INFECTIOUS_PEOPLE_LAST_KNOWN', 'false', NULL, NULL, 'false', NULL, NULL, 'true'