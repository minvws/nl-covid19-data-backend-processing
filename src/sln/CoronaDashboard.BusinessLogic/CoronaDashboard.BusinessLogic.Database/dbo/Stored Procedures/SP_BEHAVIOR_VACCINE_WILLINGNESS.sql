﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   PROCEDURE dbo.SP_BEHAVIOR_VACCINE_WILLINGNESS
AS
BEGIN
WITH BASE_CTE AS
(
SELECT [DATE_OF_MEASUREMENT]
      ,DATE_OF_REPORT
      ,[WAVE]
      ,[VALUE]
      ,IIF (INDICATOR IN ('Ja',  'Ja_eerst_weten_al_corona_gehad'),[VALUE],0) as [VACCINE_WILLINGNESS]
      ,IIF (INDICATOR IN ('Al_gevaccineerd'),[VALUE],0) as [VACCINATED]
      ,INDICATOR
  FROM [VWSINTER].[VWS_BEHAVIOR]
  WHERE REGION_CODE = 'NL00'
    AND SUBGROUP_CATEGORY = 'Alle'
    AND INDICATOR_CATEGORY = 'Vaccinatiebereidheid'
    AND INDICATOR IN ('Ja',  'Ja_eerst_weten_al_corona_gehad','Al_gevaccineerd')
    AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[VWS_BEHAVIOR])
)
  INSERT INTO VWSDEST.BEHAVIOR_VACCINE_WILLINGNESS
        (
            DATE_OF_MEASUREMENT,
            DATE_START_UNIX,
            DATE_END_UNIX,
            WAVE,
			      VACCINE_WILLINGNESS,
            VACCINATED
        )
SELECT 
  DATE_OF_MEASUREMENT 
  ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_MEASUREMENT]) AS DATE_START_UNIX
  ,dbo.CONVERT_DATETIME_TO_UNIX(DATEADD(day, 6, DATE_OF_MEASUREMENT)) AS DATE_END_UNIX
  ,WAVE
  ,CAST(SUM([VACCINE_WILLINGNESS])/100 AS NUMERIC(10,2)) AS [VACCINE_WILLINGNESS]
  ,CAST(SUM([VACCINATED])/100 AS NUMERIC(10,2)) AS [VACCINATED]

FROM BASE_CTE
GROUP BY WAVE, DATE_OF_MEASUREMENT

END;