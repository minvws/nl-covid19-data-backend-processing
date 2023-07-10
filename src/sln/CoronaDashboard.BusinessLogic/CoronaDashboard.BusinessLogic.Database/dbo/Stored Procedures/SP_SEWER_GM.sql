-- 1) CREATE VIEW(S).....
 CREATE   PROCEDURE [dbo].[SP_SEWER_GM]
 AS
 BEGIN
     -- Calculate percentages and inhabitants for each RWZI for each GM
     WITH RWZI_CTE AS (
             SELECT
             [RWZI_CODE]     AS CODE_RWZI,
             [STARTDATUM]    AS [STARTDATUM],
             [EINDDATUM]     AS [EINDDATUM],
             [INWONERS]      AS INHABITANTS,
             [REGIO_CODE]    AS GEBIEDSCODE,
             [AANDEEL]       AS [PERCENTAGE],
             [INWONERS] * ([AANDEEL]/100) AS [COVERED_INHABITANTS]
         FROM [VWSSTATIC].[CBS_POPULATION_RWZI]
         WHERE DATE_LAST_INSERTED = (select max(DATE_LAST_INSERTED) from [VWSSTATIC].[CBS_POPULATION_RWZI])
             AND REGIO_TYPE = 'GM'
     )
 
     -- Calculate average per RWZI per week
     ,BASE_CTE AS (
         SELECT T0.*
         ,T1.GEBIEDSCODE
         ,T1.[COVERED_INHABITANTS] AS APPLICABLE_INHABITANTS
         ,(T0.AVG_RNA_FLOW_PER_100000_PER_RWZI / 100000 ) * T1.[COVERED_INHABITANTS] AS AVG_RNA_FLOW_PER_RWZI
         FROM (
             SELECT
             SB.RWZI_AWZI_CODE,
             WEEK_UNIX, --Matches the monday (first day) of the week
             [dbo].[CONVERT_UNIX_TO_DATETIME](WEEK_UNIX)   AS WEEK_START,
             AVG(RNA_FLOW_PER_100000) / 1.0E+11 as AVG_RNA_FLOW_PER_100000_PER_RWZI
             , count(*) AS NUMBER_OF_MEASUREMENTS
             FROM VWSDEST.SEWER_BASE SB
             where DATE_LAST_INSERTED = (select max(DATE_LAST_INSERTED) from VWSDEST.SEWER_BASE)
             -- keep only the first measurement (some duplicate measurements per day per RWZI are present)
             and COUNT_DAILY_MEASUREMENT=1
             -- Take the average of the measurements for 1 RWZI for 1 week
             group by RWZI_AWZI_CODE, WEEK_UNIX
         ) AS T0
         -- Add percentages and inhabitants for each RWZI for each VR
         LEFT JOIN RWZI_CTE AS T1
             ON  T0.RWZI_AWZI_CODE = T1.CODE_RWZI
             AND T0.WEEK_START >= T1.STARTDATUM AND T0.WEEK_START < T1.EINDDATUM
             AND T1.PERCENTAGE > 0
     )
 
     -- Calculate the total amount of locations per GM per week.
     ,WEEK_STARTS_PER_RWZI AS (
         SELECT WEEK_START
         ,GEBIEDSCODE
         ,COUNT(CODE_RWZI) AS TOTAL_LOCATIONS
         FROM (
             SELECT DISTINCT WEEK_START
                 FROM BASE_CTE
         ) A
         LEFT JOIN RWZI_CTE R
         ON A.WEEK_START >= R.STARTDATUM AND A.WEEK_START < R.EINDDATUM
         AND R.PERCENTAGE > 0
         GROUP BY WEEK_START, GEBIEDSCODE
     )
 
     INSERT INTO VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY(
             WEEK_UNIX
         ,   GMCODE
         ,   AVERAGE_RNA_FLOW_PER_100000
         ,   NUMBER_OF_MEASUREMENTS
         ,   NUMBER_OF_LOCATIONS
         ,   TOTAL_LOCATIONS
     )
 
     SELECT
         WEEK_UNIX
         ,A.GEBIEDSCODE
         ,AVERAGE_RNA_FLOW_PER_100000
         ,NUMBER_OF_MEASUREMENTS
         ,NUMBER_OF_LOCATIONS
         ,B.TOTAL_LOCATIONS
     FROM (
         SELECT
             WEEK_UNIX
         ,   WEEK_START
         ,   GEBIEDSCODE
         ,   ROUND((SUM(AVG_RNA_FLOW_PER_RWZI) / SUM(APPLICABLE_INHABITANTS)) * 100000 , 2) as AVERAGE_RNA_FLOW_PER_100000
         ,   SUM(NUMBER_OF_MEASUREMENTS) as NUMBER_OF_MEASUREMENTS
         ,   count(*) AS NUMBER_OF_LOCATIONS
         FROM BASE_CTE
         group by WEEK_UNIX, WEEK_START, GEBIEDSCODE
     ) A
     LEFT JOIN WEEK_STARTS_PER_RWZI B
     ON A.WEEK_START = B.WEEK_START
     AND A.GEBIEDSCODE = B.GEBIEDSCODE
 END