-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Staging table for results of sewage measurements.
ALTER TABLE [VWSSTAGE].[NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS] ADD [BOVENGRENS] VARCHAR(100) NULL;
ALTER TABLE [VWSSTAGE].[NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS] ADD [GESCHAT_AANTAL] VARCHAR(100) NULL;
ALTER TABLE [VWSSTAGE].[NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS] ADD [ONDERGRENS] VARCHAR(100) NULL;

-- TODO: Delete the NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS_ABSOLUTE table but merge the data with this table.