-- CREATE VIEW(S).....
 CREATE   PROCEDURE [dbo].[SP_SEWER_NL]
 AS
 BEGIN
     WITH BASE_CTE AS (
         SELECT WEEK_GEM_PER_RWZI.*
         ,CASE
             WHEN WEEK_GEM_PER_RWZI.RWZI_AWZI_CODE = 9041 AND WEEK_UNIX < 1601856000 THEN 41974 -- Value for Zaltbommel before closing Aalst
             WHEN WEEK_GEM_PER_RWZI.RWZI_AWZI_CODE = 9025 AND WEEK_UNIX < 1607299200 THEN 56015 -- Value for Tiel before closing Lienden
             ELSE INHABITANTS
         END AS INHABITANTS
         ,CASE
             WHEN WEEK_GEM_PER_RWZI.RWZI_AWZI_CODE = 9041 AND WEEK_UNIX < 1601856000
                 THEN (AVG_RNA_FLOW_PER_100000_PER_RWZI / 100000 ) * 41974 -- Value for Zaltbommel before closing Aalst
             WHEN WEEK_GEM_PER_RWZI.RWZI_AWZI_CODE = 9025 AND WEEK_UNIX < 1607299200
                 THEN (AVG_RNA_FLOW_PER_100000_PER_RWZI / 100000 ) * 56015 -- Value for Tiel before closing Lienden
             ELSE (AVG_RNA_FLOW_PER_100000_PER_RWZI / 100000 ) * INHABITANTS
         END AS AVG_RNA_FLOW_PER_RWZI
         FROM (
             SELECT
             SB.RWZI_AWZI_CODE,
             WEEK_UNIX,
             AVG(RNA_FLOW_PER_100000) / 1.0E+11 as AVG_RNA_FLOW_PER_100000_PER_RWZI
             , count(*) AS NUMBER_OF_MEASUREMENTS
             FROM VWSDEST.SEWER_BASE SB
             where DATE_LAST_INSERTED = (select max(DATE_LAST_INSERTED) from VWSDEST.SEWER_BASE)
             -- keep only the first measurement (some duplicate measurements per day per RWZI are present)
             and COUNT_DAILY_MEASUREMENT=1
             -- Take the average of the measurements for 1 RWZI for 1 week
             group by RWZI_AWZI_CODE, WEEK_UNIX
         ) WEEK_GEM_PER_RWZI
         LEFT JOIN (
             SELECT DISTINCT CODE_RWZI, INHABITANTS
             FROM [VWSSTATIC].[RWZI_INHIBITANTS_2021]
             WHERE DATE_LAST_INSERTED = (select max(DATE_LAST_INSERTED) from [VWSSTATIC].[RWZI_INHIBITANTS_2021])
             -- Add 2 removed RWZI with 2020 data
             UNION SELECT 9029, 10495    -- Aalst
             UNION SELECT 9043, 6728     -- Lienden
         ) AS V
             ON WEEK_GEM_PER_RWZI.RWZI_AWZI_CODE = V.CODE_RWZI
     )
     INSERT INTO VWSDEST.SEWER_MEASUREMENTS(
             WEEK_UNIX
         ,   AVERAGE_RNA_FLOW_PER_100000
         ,   NUMBER_OF_MEASUREMENTS
         ,   NUMBER_OF_LOCATIONS
         ,   TOTAL_LOCATIONS
     )
     SELECT
         WEEK_UNIX
     ,   ROUND((SUM(AVG_RNA_FLOW_PER_RWZI) / SUM(INHABITANTS)) * 100000 , 2) as AVERAGE_RNA_FLOW_PER_100000
     ,   SUM(NUMBER_OF_MEASUREMENTS) as NUMBER_OF_MEASUREMENTS
     ,   count(*) AS NUMBER_OF_LOCATIONS
     ,   CASE
             WHEN WEEK_UNIX < 1601856000 THEN 317 -- Vanaf week van 5-10-2020 is RWZI Aalst (code 9029) opgeheven
             WHEN WEEK_UNIX >= 1607299200 THEN 315 -- Vanaf week van 7-12-2020 is RWZI Lienden (code 9043) opgeheven
             ELSE 316
         END AS TOTAL_NUMBER_OF_LOCATIONS
     FROM BASE_CTE group by WEEK_UNIX
 END