﻿
-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
 
 --File name has _A_ to make sure this file is executed before the view that depends on this.
 CREATE   VIEW [VWSDEST].[V_RIVM_MUTATIONS_TABULAR]
 AS
 SELECT 
        [dbo].[CONVERT_DATETIME_TO_UNIX](A.[DATE_OF_REPORT]) AS DATE_OF_REPORT_UNIX
       ,[dbo].[CONVERT_DATETIME_TO_UNIX](A.[DATE_OF_STATISTICS_WEEK_START]) AS DATE_START_UNIX
       ,[dbo].[CONVERT_DATETIME_TO_UNIX](dbo.WEEK_END(A.[DATE_OF_STATISTICS_WEEK_START])) AS DATE_END_UNIX
       ,REPLACE(A.[VARIANT_CODE], '.', '_') AS [VARIANT_CODE]
       ,A.[SORT_ORDER] AS [ORDER]
       ,A.[SAMPLE_SIZE]
       ,A.[VARIANT_CASES] AS [OCCURRENCE]
       ,A.[VARIANT_PERCENTAGE] AS [PERCENTAGE]
       ,[dbo].[CONVERT_DATETIME_TO_UNIX](A.[DATE_LAST_INSERTED]) AS DATE_OF_INSERTION_UNIX
       ,B.[LABEL_EN]
       ,B.[LABEL_NL]
   FROM [VWSDEST].[RIVM_MUTATIONS] A
   LEFT JOIN [VWSSTATIC].[MASTERDATA_VARIANTS] B ON A.[VARIANT_CODE] = B.[VARIANT_CODE]
   AND B.[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTATIC].[MASTERDATA_VARIANTS])
   WHERE A.[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[RIVM_MUTATIONS])