-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

ALTER TABLE VWSSTAGE.LNAZ_HOSPITAL_BED_OCCUPANCY
ADD IC_NIEUWE_OPNAMES_COVID VARCHAR(100);

ALTER TABLE VWSSTAGE.LNAZ_HOSPITAL_BED_OCCUPANCY
ADD KLINIEK_NIEUWE_OPNAMES_COVID VARCHAR(100);