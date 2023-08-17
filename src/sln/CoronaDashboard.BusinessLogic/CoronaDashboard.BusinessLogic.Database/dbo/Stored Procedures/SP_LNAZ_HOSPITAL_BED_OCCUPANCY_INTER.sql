-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 -- Move national data from staging to intermediate table.
 
 -- 1) CREATE STORE PROCEDURE(S) STAGE -> INTER.....
 CREATE   PROCEDURE [dbo].[SP_LNAZ_HOSPITAL_BED_OCCUPANCY_INTER]
 AS
 BEGIN
     INSERT INTO VWSINTER.LNAZ_HOSPITAL_BED_OCCUPANCY
         (   [DATUM],
             [IC_BEDDEN_COVID],
             [IC_BEDDEN_NON_COVID],
             [KLINIEK_BEDDEN],
             [IC_NIEUWE_OPNAMES_COVID],
             [KLINIEK_NIEUWE_OPNAMES_COVID]
         )    SELECT
     --- conversion of date in dd-mm-yyyy format ---
         CONVERT(DATETIME, [DATUM], 105),
     -- allow empty values and make them null
         IIF([IC_BEDDEN_COVID] IN ('', 'NA'), NULL, TRIM([IC_BEDDEN_COVID])),
         IIF([IC_BEDDEN_NON_COVID] IN ('', 'NA'), NULL, TRIM([IC_BEDDEN_NON_COVID])),
         IIF([KLINIEK_BEDDEN] IN ('', 'NA'), NULL, TRIM([KLINIEK_BEDDEN])),
         IIF([IC_NIEUWE_OPNAMES_COVID] IN ('', 'NA'), NULL, TRIM([IC_NIEUWE_OPNAMES_COVID])),
         IIF([KLINIEK_NIEUWE_OPNAMES_COVID] IN ('', 'NA'), NULL, TRIM([KLINIEK_NIEUWE_OPNAMES_COVID]))
     FROM
        VWSSTAGE.LNAZ_HOSPITAL_BED_OCCUPANCY
     WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.LNAZ_HOSPITAL_BED_OCCUPANCY)
 END;