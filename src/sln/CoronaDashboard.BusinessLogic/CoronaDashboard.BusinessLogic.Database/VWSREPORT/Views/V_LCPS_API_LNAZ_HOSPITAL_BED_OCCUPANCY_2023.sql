﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   VIEW [VWSREPORT].[V_LCPS_API_LNAZ_HOSPITAL_BED_OCCUPANCY_2023] AS
 SELECT 
     [DATE_OF_REPORT_UNIX] AS DATE_UNIX,
     [IC_BEDS_OCCUPIED_COVID] ,
     [IC_BEDS_OCCUPIED_NON_COVID],
     [IC_BEDS_OCCUPIED_COVID_PERCENTAGE],
     [NON_IC_BEDS_OCCUPIED_COVID],
     [IC_INFLUX_COVID],
     [NON_IC_INFLUX_COVID],
     dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)  AS DATE_OF_INSERTION_UNIX
 FROM [VWSDEST].[LCPS_API_LNAZ_HOSPITAL_BED_OCCUPANCY_2023]
 WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                             FROM [VWSDEST].[LCPS_API_LNAZ_HOSPITAL_BED_OCCUPANCY_2023]);