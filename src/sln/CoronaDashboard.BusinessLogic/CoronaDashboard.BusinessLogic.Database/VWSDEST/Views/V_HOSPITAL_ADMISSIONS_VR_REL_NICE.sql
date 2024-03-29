﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   VIEW VWSDEST.V_HOSPITAL_ADMISSIONS_VR_REL_NICE AS
 SELECT
     [dbo].[CONVERT_DATETIME_TO_UNIX]([WEEK_START])          AS [DATE_START_UNIX],
     [dbo].[CONVERT_DATETIME_TO_UNIX]([DATE_OF_STATISTICS])  AS [DATE_END_UNIX],
     VR_CODE AS VRCODE,
     REPORTED_PER_MIL_LAST_WEEK                              AS ADMISSIONS_PER_1M,
     dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
 FROM VWSDEST.NICE_HOSPITAL_VR
 WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED)
                             FROM VWSDEST.NICE_HOSPITAL_VR)
         AND WEEK_START IS NOT NULL; --Only records with 7 days of history