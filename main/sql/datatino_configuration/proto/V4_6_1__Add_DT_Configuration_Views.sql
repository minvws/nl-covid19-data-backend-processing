-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertView] 'VWSDEST.V_HOSPITAL_ADMISSIONS_NICE', 'DATE_OF_REPORT_UNIX'

exec [dbo].[SafeInsertView] 'VWSDEST.V_IC_BED_OCCUPANCY', 'DATE_OF_REPORT_UNIX'
exec [dbo].[SafeInsertView] 'VWSDEST.V_NON_IC_BED_OCCUPANCY', 'DATE_OF_REPORT_UNIX'

GO
