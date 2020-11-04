-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertView] 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PER_REGION', 'DATE_OF_REPORT_UNIX'
exec [dbo].[SafeInsertView] 'VWSDEST.V_HOSPITAL_ADMISSIONS_PER_REGION', 'DATE_OF_REPORT_UNIX'
exec [dbo].[SafeInsertView] 'VWSDEST.V_DECEASED_PER_REGION', 'DATE_OF_REPORT_UNIX'
exec [dbo].[SafeInsertView] 'VWSDEST.V_POS_TESTED_PEOPLE_PER_MUNICIPALITY_LAST', 'DATE_OF_REPORT_UNIX'
exec [dbo].[SafeInsertView] 'VWSDEST.V_HOSP_ADMISSIONS_PER_MUNICIPALITY_LAST', 'DATE_OF_REPORT_UNIX'
exec [dbo].[SafeInsertView] 'VWSDEST.V_DECEASED_PER_MUNICIPALITY_LAST', 'DATE_OF_REPORT_UNIX'
exec [dbo].[SafeInsertView] 'VWSDEST.V_POSITIVE_TESTED_PEOPLE_PERCENTAGE', 'DATE_OF_REPORT_UNIX'
exec [dbo].[SafeInsertView] 'VWSDEST.V_ESCALATIONLEVELS_PER_REGION', 'DATE_OF_REPORT_UNIX'
exec [dbo].[SafeInsertView] 'VWSDEST.V_SEWER_MEASUREMENTS_PER_RWZI_REG', 'DATE_MEASUREMENT_UNIX'

GO