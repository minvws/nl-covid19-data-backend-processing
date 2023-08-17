﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 -- JSON-KEY: nice_hospital FOR NL.json
 
 CREATE   VIEW VWSDEST.V_HOSPITAL_ADMISSIONS_NL_NICE AS
 SELECT
     dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_STATISTICS]) AS DATE_UNIX
 ,   HOSPITALIZED AS ADMISSIONS_ON_DATE_OF_ADMISSION
 ,   HOSPITALIZED_7D_AVG_CUTOFF AS ADMISSIONS_ON_DATE_OF_ADMISSION_MOVING_AVERAGE
 ,   CAST(ROUND(HOSPITALIZED_7D_AVG_CUTOFF,0) AS INTEGER) AS ADMISSIONS_ON_DATE_OF_ADMISSION_MOVING_AVERAGE_ROUNDED
 ,   REPORTED AS ADMISSIONS_ON_DATE_OF_REPORTING
 ,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)  AS DATE_OF_INSERTION_UNIX
 FROM VWSDEST.NICE_HOSPITAL_NL WITH(NOLOCK)
 WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.NICE_HOSPITAL_NL WITH(NOLOCK))