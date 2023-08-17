﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.
 
 -- 1) CREATE VIEW(S).....
 CREATE   VIEW [VWSREPORT].[V_PBI_ANNOTATIONS]
 AS
     SELECT 
         CONVERT(DATE, [START_DATE], 105) AS [START_DATE],
         CONVERT(DATE, [END_DATE], 105) AS [END_DATE],
         [TITLE],
         [DESCRIPTION],
         [CATEGORY],
         [SHORT_DESCRIPTION],
         [LONG_DESCRIPTION]
     FROM [VWSREPORT].[ANNOTATIONS]