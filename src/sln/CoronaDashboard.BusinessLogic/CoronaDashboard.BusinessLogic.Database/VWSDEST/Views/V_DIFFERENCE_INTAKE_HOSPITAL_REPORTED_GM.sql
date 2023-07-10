﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor  more information.
 
 --Previously [VWSDEST].[V_DIFFERENCE_HOSPITAL_ADMISSIONS__MOVING_AVERAGE_HOSPITAL_NICE] was used
 CREATE   VIEW [VWSDEST].[V_DIFFERENCE_INTAKE_HOSPITAL_REPORTED_GM]
 AS
 SELECT
     DATE_OF_REPORT
     ,NEW_DATE_OF_REPORT_UNIX AS NEW_DATE_UNIX
     ,OLD_DATE_OF_REPORT_UNIX AS OLD_DATE_UNIX
     ,GMCODE
     ,CAST(OLD_VALUE AS INT) AS [OLD_VALUE]
     ,CAST(DIFFERENCE AS INT) AS [DIFFERENCE]
 FROM VWSDEST.NICE_HOSPITAL_GM_BASE
 WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.NICE_HOSPITAL_GM_BASE)