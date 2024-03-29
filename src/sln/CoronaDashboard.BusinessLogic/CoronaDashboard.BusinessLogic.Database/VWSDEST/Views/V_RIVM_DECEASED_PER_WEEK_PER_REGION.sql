﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 CREATE   VIEW [VWSDEST].[V_RIVM_DECEASED_PER_WEEK_PER_REGION]
 AS
 SELECT
     DECEASED_ACTUAL AS COVID_DAILY
 ,   SUM(DECEASED_ACTUAL) OVER(PARTITION BY VRCODE ORDER BY WEEK_START_UNIX ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS COVID_TOTAL
 ,   VRCODE
 ,   WEEK_START_UNIX AS DATE_UNIX
 ,   [dbo].[CONVERT_DATETIME_TO_UNIX](DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
 FROM [VWSDEST].[RIVM_DECEASED_PER_WEEK]
 WHERE WEEK_START >= '2020-03-16 00:00:00.000'
 AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[RIVM_DECEASED_PER_WEEK])
 AND dbo.CONVERT_UNIX_TO_DATETIME(WEEK_START_UNIX) < '2022-12-26' -- added as RIVM reports 9999 after this date