-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertProto] 'MUNICIPALITIES', 'name|code', 'MUNICIPALITIES|MUNICIPALITIES', 'true'
exec [dbo].[SafeInsertProto] 'REGIONS', 'name|code', 'REGIONS|REGIONS', 'true'

GO