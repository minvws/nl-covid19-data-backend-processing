-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   PROCEDURE [dbo].[SP_POSITIVE_TESTED_PEOPLE_WEEKLY]
AS
BEGIN
--Move positively tested persons data from intermediate table to destination table. 

WITH AGEGROUP_POPULATION_DATERANGE AS (
SELECT 
	 DATUM_PEILING AS DATE_FROM
    -- 2100-01-01 is used as convention for the most recent versions as no end date is known yet.
    ,ISNULL(LEAD(DATUM_PEILING,1) OVER (ORDER BY [DATUM_PEILING] ASC),CAST('2100-01-01' AS DATE)) AS DATE_TO
	,CAST(POPULATIE AS FLOAT) AS [POPULATION] --enable proper division
FROM [VWSSTATIC].[CBS_POPULATION_NL]
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.CBS_POPULATION_NL)--Determine ranges in which population numbers should be used
)
,
--Determine the number of reports per municipality
BASE_CTE AS (
        SELECT
            CAST(DATE_OF_PUBLICATION AS DATE) AS DATE_OF_REPORT,
            TOTAL_REPORTED AS [INFECTED],
            MUNICIPALITY_CODE
        FROM
            VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY
        WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY)
            AND DATE_OF_PUBLICATION > '1900-01-01 00:00:00.000'
)
--Determine the number of reports on NL level, and determine time features
, 
DAY_TOTALS_CTE AS (
    SELECT 
        DATE_OF_REPORT,
        CAST(dbo.WEEK_END(DATE_OF_REPORT)                      AS DATE)    AS WEEK_END,
        CAST(DATEADD(DAY, -6, dbo.WEEK_END(DATE_OF_REPORT))    AS DATE)    AS WEEK_START,
        dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_REPORT)                       AS DATE_OF_REPORT_UNIX,
        SUM(CAST(INFECTED AS FLOAT)) AS [INFECTED]
    FROM BASE_CTE T1
	    GROUP BY DATE_OF_REPORT
		) 	
,
--Calculate the total number of reports per week
WEEK_TOTALS_CTE AS 
(
    SELECT 
            WEEK_START,
            WEEK_END,
            COUNT(DATE_OF_REPORT)       AS DAYS_IN_WEEK,
            SUM(INFECTED)         AS INFECTED
    FROM DAY_TOTALS_CTE
    GROUP BY WEEK_START,WEEK_END
    -- ORDER BY DATE_OF_REPORT
    HAVING COUNT(DATE_OF_REPORT) >= 7 -- Do not show incomplete weeks
)
,
RUNNING_TOTALS_CTE AS
(
    SELECT 
            WEEK_START,
            WEEK_END,
            INFECTED,
            SUM(INFECTED)           OVER (ORDER BY WEEK_END ASC) AS INFECTED_CML,
            SUM(INFECTED)           OVER (ORDER BY WEEK_END ASC ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS [INFECTED_14D],
            T1.[POPULATION],
            LAG(T1.[POPULATION])    OVER (ORDER BY WEEK_END) AS [POPULATION_14D]
    FROM WEEK_TOTALS_CTE AS T0
    --Use the population at the first day of the weekrange
        LEFT JOIN AGEGROUP_POPULATION_DATERANGE T1 
            ON  (T0.WEEK_START >= T1.DATE_FROM AND T0.WEEK_START < T1.DATE_TO)
    -- ORDER BY WEEK_END DESC
)
	INSERT INTO VWSDEST.POSITIVE_TESTED_PEOPLE_WEEKLY
        (
        WEEK_START,
        WEEK_END,
        TOT_INFECTED,
        TOT_INFECTED_RATE, 
        TOT_INFECTED_CML,
        TOT_INFECTED_14D,
        TOT_INFECTED_14D_RATE,
        REL_INFECTED,
        REL_INFECTED_RATE,
        REL_INFECTED_CML,
        REL_INFECTED_14D,
        REL_INFECTED_14D_RATE,
        [POPULATION]
        )
SELECT 
        --Time indication
        WEEK_START,
        WEEK_END,

        --Total numbers
        INFECTED                                            AS TOT_INFECTED, --weektotal
        INFECTED / 7                                        AS TOT_INFECTED_RATE, --daily rate
        INFECTED_CML                                        AS TOT_INFECTED_CML, --cumulative
        INFECTED_14D                                        AS TOT_INFECTED_14D, --14 day total
        INFECTED_14D / 14                                   AS TOT_INFECTED_14D_RATE, --14 day, daily rate

        --Relative Numbers
        INFECTED           / ([POPULATION]    /100000.0)    AS REL_INFECTED,
        (INFECTED / 7)     / ([POPULATION]    /100000.0)    AS REL_INFECTED_RATE,
        INFECTED           / ([POPULATION]    /100000.0)    AS REL_INFECTED_CML,
        INFECTED_14D       / ([POPULATION_14D]/100000.0)    AS REL_INFECTED_14D,
        (INFECTED / 14)    / ([POPULATION_14D]/100000.0)    AS REL_INFECTED_14D_RATE,


        --Population
        [POPULATION]
 
FROM RUNNING_TOTALS_CTE AS T0
END;