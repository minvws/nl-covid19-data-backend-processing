-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertView] 'VWSDEST.V_NURSING_HOMES_NATIONAL', 'DATE_OF_REPORT_UNIX'
exec [dbo].[SafeInsertView] 'VWSDEST.V_NURSING_HOMES_PER_REGION', 'DATE_OF_REPORT_UNIX'
exec [dbo].[SafeInsertView] 'VWSDEST.V_NURSING_HOME_REGIONS', 'DATE_OF_REPORT_UNIX'

GO