-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertWorkflow] 'NICE_HOSPITAL_ADMISSIONS_NATIONAL', 'Day', '12:17', 'N', 'true';
exec [dbo].[SafeInsertWorkflow] 'LNAZ_HOSPITAL_BED_OCCUPANCY', 'Day', '12:17', 'N', 'true';

GO