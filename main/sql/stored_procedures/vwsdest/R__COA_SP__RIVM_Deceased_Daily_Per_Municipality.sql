-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE [dbo].[SP_RIVM_DECEASED_DAILY_PER_MUNICIPALITY]
AS
BEGIN

WITH BASE_CTE AS (
SELECT
     DATE_OF_PUBLICATION
,   SUM(DECEASED) AS DECEASED_ACTUAL
,   MUNICIPALITY_CODE
FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY)
GROUP BY DATE_OF_PUBLICATION, MUNICIPALITY_CODE)


INSERT INTO VWSDEST.RIVM_DECEASED_DAILY_PER_MUNICIPALITY
	(
	    DATE_OF_REPORT
	,   DATE_OF_REPORT_UNIX
	,   MUNICIPALITY_CODE	  
	,   OLD_DATE_OF_REPORT  
	,	OLD_DATE_OF_REPORT_UNIX 
	,   OLD_VALUE 
	,   [DIFFERENCE] 
	,   DECEASED_ACTUAL
	,   DECEASED_CUMULATIVE
	)
SELECT
	DATE_OF_PUBLICATION                                     AS  [DATE_OF_PUBLICATION]
	,dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_PUBLICATION)	    AS  [DATE_OF_PUBLICATION_UNIX] 
	,MUNICIPALITY_CODE                                      AS  MUNICIPALITY_CODE                
	,LAG([DATE_OF_PUBLICATION], 1, NULL) OVER (
		PARTITION BY MUNICIPALITY_CODE
		ORDER BY DATE_OF_PUBLICATION)						AS [OLD_DATE_OF_PUBLICATION]

	,dbo.CONVERT_DATETIME_TO_UNIX(LAG([DATE_OF_PUBLICATION], 1, NULL) OVER (
		PARTITION BY MUNICIPALITY_CODE
		ORDER BY DATE_OF_PUBLICATION))						AS [OLD_DATE_OF_PUBLICATION_UNIX]

	,ISNULL(
		LAG(DBO.NO_NEGATIVE_NUMBER_I([DECEASED_ACTUAL]), 1, NULL)  OVER (
			PARTITION BY MUNICIPALITY_CODE
			ORDER BY  DATE_OF_PUBLICATION)
		,0)													AS [OLD_VALUE]
	,ISNULL(
		DBO.NO_NEGATIVE_NUMBER_I([DECEASED_ACTUAL]) -	LAG(DBO.NO_NEGATIVE_NUMBER_I([DECEASED_ACTUAL]), 1, NULL) OVER (
															PARTITION BY MUNICIPALITY_CODE
															ORDER BY DATE_OF_PUBLICATION)	
		,0)
														
															AS [DIFFERENCE]
	,DECEASED_ACTUAL
	,SUM(DECEASED_ACTUAL) OVER(
		PARTITION BY MUNICIPALITY_CODE 
		ORDER BY DATE_OF_PUBLICATION 
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)   AS COVID_TOTAL  
FROM BASE_CTE
GROUP BY MUNICIPALITY_CODE, DATE_OF_PUBLICATION, DECEASED_ACTUAL

END
GO