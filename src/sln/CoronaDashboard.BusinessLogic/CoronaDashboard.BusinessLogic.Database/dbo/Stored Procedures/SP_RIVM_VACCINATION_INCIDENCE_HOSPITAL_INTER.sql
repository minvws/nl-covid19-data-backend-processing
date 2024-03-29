﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE DBO.SP_RIVM_VACCINATION_INCIDENCE_HOSPITAL_INTER
AS
BEGIN
    INSERT INTO VWSINTER.RIVM_VACCINATION_INCIDENCE_HOSPITAL
    (
       [ID],
	   [DATUM_PERIODE_START],
	   [DATUM_PERIODE_EINDE],
	   [lEEFTIJDSCOHORT_CATEGORIE],
	   [LEEFTIJDSCOHORT_CATEGORIE_LABEL],
	   [VACC_STATUS],
	   [INCIDENTIE_OPNAMES_GEM]
    )
    SELECT
       [ID]
      ,CONVERT (date, [DATUM_PERIODE_START], 105)  AS [DATUM_PERIODE_START]
      ,CONVERT (date, [DATUM_PERIODE_EINDE], 105) AS  [DATUM_PERIODE_EINDE]
      ,CAST ([lEEFTIJDSCOHORT_CATEGORIE] AS INT) AS [lEEFTIJDSCOHORT_CATEGORIE]
      ,[LEEFTIJDSCOHORT_CATEGORIE_LABEL]
	  ,[VACC_STATUS]
      ,CAST(replace([INCIDENTIE_OPNAMES_GEM], ',', '.') AS decimal(10,2)) AS [INCIDENTIE_OPNAMES_GEM]
    FROM 
       VWSSTAGE.RIVM_VACCINATION_INCIDENCE_HOSPITAL
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.RIVM_VACCINATION_INCIDENCE_HOSPITAL)
END;