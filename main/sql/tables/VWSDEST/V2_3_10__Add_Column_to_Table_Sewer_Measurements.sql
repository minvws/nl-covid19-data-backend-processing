-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Production table for results of sewage measurements.
ALTER TABLE [VWSDEST].[SEWER_MEASUREMENTS]
ADD NUMBER_OF_MEASUREMENTS INT NULL;