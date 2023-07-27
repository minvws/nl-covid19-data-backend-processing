-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.
 
 -- 1) CREATE STORE PROCEDURE(S) INTER -> DEST.....
 CREATE   PROCEDURE [DBO].[SP_LCPS_API_LNAZ_HOSPITAL_BED_OCCUPANCY_2023_INTER_TO_DEST]
 AS
 BEGIN
     INSERT INTO [VWSDEST].[LCPS_API_LNAZ_HOSPITAL_BED_OCCUPANCY_2023] (
         [DATE_OF_REPORT],
         [DATE_OF_REPORT_UNIX],
         [IC_BEDS_OCCUPIED_COVID],
         [IC_BEDS_OCCUPIED_NON_COVID],
         [IC_BEDS_OCCUPIED_COVID_PERCENTAGE],
         [NON_IC_BEDS_OCCUPIED_COVID],
         [IC_INFLUX_COVID],
         [NON_IC_INFLUX_COVID]
     )
     SELECT 
         [DATUM]                                                                                                 AS DATE_OF_REPORT,
         dbo.CONVERT_DATETIME_TO_UNIX([DATUM])                                                                   AS DATE_OF_REPORT_UNIX,
         [IC_BEZETTING_COVID]                                                                                    AS IC_BEDS_OCCUPIED_COVID,
         [IC_BEZETTING_NONCOVID]                                                                                 AS IC_BEDS_OCCUPIED_NON_COVID,
         --If either IC_BEDDEN_COVID or IC_BEDDEN_NON_COVID equals NULL, NULL is the result of the line below
         ROUND((CAST([IC_BEZETTING_COVID] as DECIMAL)/([IC_BEZETTING_NONCOVID]+[IC_BEZETTING_COVID]) * 100.0),2) AS IC_BEDS_OCCUPIED_COVID_PERCENTAGE,
         [KLINIEK_BEZETTING_COVID]                                                                               AS NON_IC_BEDS_OCCUPIED_COVID,
         [IC_OPNAMES_COVID]                                                                                      AS IC_INFLUX_COVID,
         [KLINIEK_OPNAMES_COVID]                                                                                 AS NON_IC_INFLUX_COVID
     FROM [VWSINTER].[LCPS_API_LNAZ_HOSPITAL_BED_OCCUPANCY_2023]
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[LCPS_API_LNAZ_HOSPITAL_BED_OCCUPANCY_2023])
 END