-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.


-- Since flyway does not delete datatino data this allows us to run the migration multiple times.
-- Make all workflows initiated from the previous migration-file inactive
-- TODO!!

-- Insert workflows into table
-- Perform a safe insert because flyway does not clear datatino tables
exec [dbo].[SafeInsertWorkflow] 'RIVM_COVID_19_CASE_NATIONAL', 'Day', 'N';
exec [dbo].[SafeInsertWorkflow] 'FOUNDATION_NICE_IC_INTAKE_COUNT', 'Day', 'N'
exec [dbo].[SafeInsertWorkflow] 'RIVM_COVID_19_NUMBER_MUNICIPALITY_CUMULATIVE', 'Day', 'N'
exec [dbo].[SafeInsertWorkflow] 'RIVM_REPRODUCTION_NUMBER', 'Week', 'N'
exec [dbo].[SafeInsertWorkflow] 'RIVM_INFECTIOUS_PEOPLE', 'Week', 'N'
exec [dbo].[SafeInsertWorkflow] 'RIVM_NURSING_HOME_INTAKE', 'Day', 'N'
exec [dbo].[SafeInsertWorkflow] 'NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS', 'Week', 'N'
exec [dbo].[SafeInsertWorkflow] 'RIVM_SEWER_MEASUREMENTS', 'Week', 'N'
exec [dbo].[SafeInsertWorkflow] 'NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS_ABSOLUTE', 'Week', 'N'
GO