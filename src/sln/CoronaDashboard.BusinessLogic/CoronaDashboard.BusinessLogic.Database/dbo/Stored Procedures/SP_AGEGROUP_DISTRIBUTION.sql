-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE   PROCEDURE [dbo].[SP_AGEGROUP_DISTRIBUTION]
AS
BEGIN

WITH BASE_CTE  AS (

-- Joining the mapping of agegroup codes and their respective description to the population numbers per agegroup code 
SELECT T2.[DESCRIPTION]
      ,T1.[BEVOLKINGOP1JANUARI_1]
      ,T1.[DATE_LAST_INSERTED]
  FROM [VWSSTATIC].[CBS_INHABITANTS_PER_AGEGROUP] T1
  LEFT JOIN (SELECT *
				FROM [VWSSTATIC].[CBS_AGEGROUP_MAPPING]
				WHERE [DATE_LAST_INSERTED] = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSSTATIC].[CBS_AGEGROUP_MAPPING]) ) T2
	ON T1.[LEEFTIJD] = T2.[KEY]
  WHERE T1.[DATE_LAST_INSERTED] = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSSTATIC].[CBS_INHABITANTS_PER_AGEGROUP])
),

--Summing the population numbers per age group 
SECOND_CTE AS (
SELECT [DESCRIPTION] AS [AGEGROUP]
	  ,SUM([BEVOLKINGOP1JANUARI_1]) AS [INHABITANTS]
FROM BASE_CTE
GROUP BY [DESCRIPTION]
)

INSERT INTO VWSSTATIC.CBS_AGEGROUP_DISTRIBUTION
    ([AGEGROUP], [INHABITANTS], [INHABITANTS_PERCENTAGE])

SELECT [AGEGROUP]
	  ,[INHABITANTS]
--Dividing the population numbers per agegroup by the total amount of the population across all age groups to receive the respective percentage
	  ,CAST((CAST([INHABITANTS] as decimal(15,3))/(SELECT SUM(INHABITANTS) FROM SECOND_CTE WHERE AGEGROUP IS NOT NULL)) as decimal(10,3))  AS [INHABITANTS_PERCENTAGE]
FROM SECOND_CTE

END;