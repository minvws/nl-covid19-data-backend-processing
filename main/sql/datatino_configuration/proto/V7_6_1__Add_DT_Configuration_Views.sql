-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertView] 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_SMALL_AGE_GROUP', 'DATE_OF_REPORT_UNIX'

GO