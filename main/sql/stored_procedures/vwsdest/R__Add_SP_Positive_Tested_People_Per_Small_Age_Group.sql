-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Stored procedure for creating infected people per age group
CREATE OR ALTER PROCEDURE DBO.SP_POSITIVE_TESTED_PEOPLE_PER_SMALL_AGE_GROUP
AS
BEGIN
-- Move data from intermediate table to destination table.

-- Base CTE (Common Table Expression) is the first selection on the source table. AGEGROUP is converted to a new form. Number of infected is added to allow for easier summarizing of data later on.
WITH BASE_CTE AS (
SELECT 
	T1.DATE_FILE
,	DATE_LAST_INSERTED
,   CAST(CASE AGEGROUP
             WHEN '<50'		THEN 'Unknown'
             ELSE AGEGROUP
     END AS VARCHAR(100)) AS [AGEGROUP]
,	1 AS [NUMBER_OF_INFECTED]
FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL T1
-- Inner join to only select the max DATE_LAST_INSERTED per DATE_FILE
INNER JOIN (SELECT DATE_FILE, MAX(DATE_LAST_INSERTED) AS [MAX_DATE_LAST_INSERTED] FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL GROUP BY DATE_FILE) T2 
ON T1.DATE_FILE = T2.DATE_FILE AND T1.DATE_LAST_INSERTED = T2.[MAX_DATE_LAST_INSERTED])

-- The second CTE adds logic to calculate the number of infected per age group and per day. Three columns are calculated: number of infected, number of infected for previous day and increase based on difference between the two dates.  
, SECOND_CTE AS (
SELECT 
	DATE_FILE 
,	DATE_LAST_INSERTED
,	AGEGROUP
,	SUM(NUMBER_OF_INFECTED)																												AS [NUMBER_OF_INFECTED]
,	LAG (SUM(NUMBER_OF_INFECTED),1) OVER (PARTITION BY AGEGROUP ORDER BY AGEGROUP, DATE_FILE ASC)										AS [NUMBER_OF_INFECTED_PREVIOUS_DAY]
,	ISNULL(SUM(NUMBER_OF_INFECTED) - LAG (SUM(NUMBER_OF_INFECTED),1) OVER (PARTITION BY AGEGROUP ORDER BY AGEGROUP, DATE_FILE ASC), 0)	AS [INCREASE_OF_INFECTED]
FROM BASE_CTE
GROUP BY DATE_FILE, AGEGROUP, DATE_LAST_INSERTED)

-- Final select and insert into statement, where only the max date is filtered out using an inner join on the max date. 
INSERT INTO VWSDEST.POSITIVE_TESTED_PEOPLE_PER_SMALL_AGE_GROUP
    (DATE_OF_REPORT, DATE_OF_REPORT_UNIX, AGEGROUP, INFECTED_PER_AGEGROUP_INCREASE, NUMBER_OF_INFECTED, NUMBER_OF_INFECTED_PREVIOUS_DAY)
SELECT 
	DATE_FILE AS [DATE_OF_REPORT]
,	DATEDIFF(SECOND,{d '1970-01-01'}, CONVERT(DATETIME, DATE_FILE, 101)) AS [DATE_OF_REPORT_UNIX]
,	T1.AGEGROUP
,	INCREASE_OF_INFECTED
,	NUMBER_OF_INFECTED
,	NUMBER_OF_INFECTED_PREVIOUS_DAY
FROM SECOND_CTE T1

--Join to select max datelastinserted per age group
INNER JOIN (SELECT AGEGROUP, MAX(DATE_LAST_INSERTED) AS DATE_LAST_INSERTED FROM SECOND_CTE GROUP BY AGEGROUP) T2 
ON T1.AGEGROUP = T2.AGEGROUP AND T1.DATE_LAST_INSERTED = T2.DATE_LAST_INSERTED

END;