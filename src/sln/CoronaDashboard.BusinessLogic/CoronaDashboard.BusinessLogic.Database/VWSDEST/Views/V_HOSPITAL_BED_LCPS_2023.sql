-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   VIEW [VWSDEST].[V_HOSPITAL_BED_LCPS_2023] AS
 SELECT 
     [DATE_OF_REPORT_UNIX] AS DATE_UNIX,
     [NON_IC_BEDS_OCCUPIED_COVID] as beds_occupied_covid,
     [NON_IC_INFLUX_COVID] AS [INFLUX_COVID_PATIENTS],
     dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)  AS DATE_OF_INSERTION_UNIX
 FROM [VWSDEST].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023]
 WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                             FROM [VWSDEST].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023]);