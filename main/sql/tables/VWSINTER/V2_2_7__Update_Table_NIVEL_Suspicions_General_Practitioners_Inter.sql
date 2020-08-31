-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

-- Intermediate table for results of sewage measurements.
ALTER TABLE [VWSINTER].[NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS] ADD [BOVENGRENS] INT NULL;
ALTER TABLE [VWSINTER].[NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS] ADD [GESCHAT_AANTAL] INT NULL;
ALTER TABLE [VWSINTER].[NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS] ADD [ONDERGRENS] INT NULL;

-- TODO: Delete the NIVEL_SUSPICIONS_GENERAL_PRACTITIONERS_ABSOLUTE table but merge the data with this table.