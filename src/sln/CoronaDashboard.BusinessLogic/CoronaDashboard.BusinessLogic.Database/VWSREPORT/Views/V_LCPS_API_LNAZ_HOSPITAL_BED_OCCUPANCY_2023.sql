﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   VIEW [VWSREPORT].[V_LCPS_API_LNAZ_HOSPITAL_BED_OCCUPANCY_2023] AS
 SELECT 
      [DATE_LAST_INSERTED]
      ,[DATUM]
      ,[IC_CAPACITEIT_TOTAAL]
      ,[KLINIEK_CAPACITEIT_TOTAAL]
      ,[IC_BEZETTING_COVID]
      ,[IC_BEZETTING_COVID_INTERNATIONAAL]
      ,[IC_BEZETTING_ONTLABELD]
      ,[IC_BEZETTING_NONCOVID]
      ,[KLINIEK_BEZETTING_COVID]
      ,[KLINIEK_BEZETTING_ONTLABELD]
      ,[KLINIEK_BEZETTING_NONCOVID]
      ,[IC_OPNAMES_COVID]
      ,[KLINIEK_OPNAMES_COVID]
  FROM [VWSINTER].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023] -- Raw data view for PowerBI (see COR-1861)
  WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                             FROM [VWSINTER].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023]);
