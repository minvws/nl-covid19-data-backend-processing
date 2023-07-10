-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 CREATE   VIEW [VWSREPORT].[V_PBI_Bedbezetting]
 AS 
     SELECT 
         CAST([DATE_OF_REPORT] as date)                              AS [Datum]        
         ,[IC_BEDS_OCCUPIED_COVID]                                   AS [Bedbezetting IC (COVID)]
         ,[IC_BEDS_OCCUPIED_NON_COVID]                               AS [Bedbezetting IC (non-COVID)]
         ,[IC_BEDS_OCCUPIED_NON_COVID] + [IC_BEDS_OCCUPIED_COVID]    AS [Bedbezetting IC]
         ,[NON_IC_BEDS_OCCUPIED_COVID]                               AS [Bedbezetting]
         ,CAST([DATE_LAST_INSERTED] as date)                         AS [Update datum]
     FROM [VWSDEST].[HOSPITAL_BED_OCCUPANCY]
     WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[HOSPITAL_BED_OCCUPANCY])
     AND DATE_OF_REPORT < '2022-12-12'
 
 UNION ALL
 
     SELECT 
         CAST([DATE_OF_REPORT] as date)                              AS [Datum]        
         ,[IC_BEDS_OCCUPIED_COVID]                                   AS [Bedbezetting IC (COVID)]
         ,[IC_BEDS_OCCUPIED_NON_COVID]                               AS [Bedbezetting IC (non-COVID)]
         ,[IC_BEDS_OCCUPIED_NON_COVID] + [IC_BEDS_OCCUPIED_COVID]    AS [Bedbezetting IC]
         ,[NON_IC_BEDS_OCCUPIED_COVID]                               AS [Bedbezetting]
         ,CAST([DATE_LAST_INSERTED] as date)                         AS [Update datum]
     FROM [VWSDEST].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023]
     WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023])
     AND DATE_OF_REPORT >= '2022-12-12'