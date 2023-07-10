-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   PROCEDURE [dbo].[SP_VACCINATION_INCIDENCE_HOSPITAL_DEST]
AS
BEGIN
      --Insert final output into dest table
    INSERT INTO [VWSDEST].[RIVM_VACCINATION_INCIDENCE_HOSPITAL]
         (
         DATE_START,
         DATE_END,
         AGE_GROUP_RANGE,
         HAS_ONE_SHOT_OR_NOT_VACCINATED_PER_100K,
         FULLY_VACCINATED_PER_100K
         )
    SELECT [DATUM_PERIODE_START]           AS [DATE_START]
    ,[DATUM_PERIODE_EINDE]                 AS [DATE_END]
    ,[LEEFTIJDSCOHORT_CATEGORIE_LABEL]     AS [AGE_GROUP_RANGE]
    ,[Niet gevaccineerd]                   AS [HAS_ONE_SHOT_OR_NOT_VACCINATED_PER_100K]
    ,[Volledig gevaccineerd]               AS [FULLY_VACCINATED_PER_100K]
    FROM (
          SELECT
               [DATUM_PERIODE_START],
               [DATUM_PERIODE_EINDE],
               [lEEFTIJDSCOHORT_CATEGORIE],
               [LEEFTIJDSCOHORT_CATEGORIE_LABEL],
               [VACC_STATUS],
               [INCIDENTIE_OPNAMES_GEM]
          FROM VWSINTER.RIVM_VACCINATION_INCIDENCE_HOSPITAL
          where DATE_LAST_INSERTED = (select max(DATE_LAST_INSERTED) from [VWSINTER].[RIVM_VACCINATION_INCIDENCE_HOSPITAL])
    ) INTER
    PIVOT (
      SUM([INCIDENTIE_OPNAMES_GEM])
      FOR [VACC_STATUS]
      IN (
        [Niet gevaccineerd],
        [Volledig gevaccineerd]
      )
    ) AS PivotTable
END