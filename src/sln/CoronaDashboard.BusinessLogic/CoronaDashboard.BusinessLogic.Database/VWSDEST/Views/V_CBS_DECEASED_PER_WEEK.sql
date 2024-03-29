﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN   VOLKSGEZONDHEID, WELZIJN EN SPORT. 
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.
 
 CREATE   VIEW [VWSDEST].[V_CBS_DECEASED_PER_WEEK]
 AS
     SELECT
         [DECEASED_ACTUAL] AS [REGISTERED],
         [DECEASED_FORECAST] AS [EXPECTED],
         [DECEASED_FORECAST_LOW] AS [EXPECTED_MIN],
         [DECEASED_FORECAST_HIGH] AS [EXPECTED_MAX],
         [WEEK_START_UNIX] AS [DATE_START_UNIX],
         [WEEK_END_UNIX] AS [DATE_END_UNIX],
         [DBO].[CONVERT_DATETIME_TO_UNIX]([DATE_LAST_INSERTED]) AS [DATE_OF_INSERTION_UNIX]
     FROM [VWSDEST].[CBS_DECEASED_PER_WEEK] WITH(NOLOCK)
     WHERE [WEEK_START] >= '2020-03-16 00:00:00.000'
         AND [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[CBS_DECEASED_PER_WEEK] WITH(NOLOCK));