-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   PROCEDURE DBO.SP_ECDC_CASES
 AS
 BEGIN
     INSERT INTO VWSDEST.ECDC_CASES
     (
         [COUNTRY],
         [COUNTRY_CODE],
         [CONTINENT],
         [POPULATION],
         [INDICATOR],
         [YEAR_WEEK],
         [WEEK_START],
         [WEEK_END],
         [RATE_14_DAY],
         [CUMULATIVE_COUNT],
         [SOURCE],
         [INFECTED_TOTAL],
         [INFECTED_TOTAL_AVERAGE],
         [INFECTED_PER_100K],
         [INFECTED_PER_100K_AVERAGE]
     )
     SELECT
         [COUNTRY],
         [COUNTRY_CODE],
         [CONTINENT],
         [POPULATION],
         [INDICATOR],
         [YEAR_WEEK],
         [WEEK_START],
         [WEEK_END],
         [RATE_14_DAY],
         [CUMULATIVE_COUNT],
         [SOURCE],
         --Total refers to week totals. Average refers to daily averages, hence the weektotals / 7
         [WEEKLY_COUNT] AS [INFECTED_TOTAL],
         (CAST([WEEKLY_COUNT] AS FLOAT)/7) AS INFECTED_TOTAL_AVERAGE,
         [WEEKLY_COUNT] / (CAST([POPULATION] AS FLOAT)/100000) AS INFECTED_PER_100K,
         (CAST([WEEKLY_COUNT] AS FLOAT)/7) / (CAST([POPULATION] AS FLOAT)/100000) AS INFECTED_PER_100K_AVERAGE
     FROM 
        VWSINTER.ECDC_CASES
     WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSINTER.ECDC_CASES)
         AND [INDICATOR] = 'cases'
         AND COUNTRY_CODE IN (
         'AUT',
         'BEL',
         'BGR',
         'CHE',
         'CYP',
         'CZE',
         'DEU',
         'DNK',
         'ESP',
         'EST',
         'FIN',
         'FRA',
         'GBR',
         'GRC',
         'HRV',
         'HUN',
         'IRL',
         'ISL',
         'ITA',
         'LIE',
         'LTU',
         'LUX',
         'LVA',
         'MLT',
         'NLD',
         'NOR',
         'POL',
         'PRT',
         'ROU',
         'SVK',
         'SVN',
         'SWE'
     )
 END;