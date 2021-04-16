-- This script returns the indication of the missing indexes according to some intuitive energy definition drawn upon the basic stats
-- the server provides, complete with the statement needed to create them. Example run (production, 26-1-21; add 'ORDER BY Energy DESC'):
--
-- DatabaseID	Avg_Estimated_Impact	Last_User_Seek	Cum_Avg_Estimated_Impact	Create_Statement	Energy	Energy_Total
-- 5	282638,4	2021-01-26 09:56:29.903	817580,41	CREATE INDEX [IX_NICE_HOSPITAL_GM_BASE_GMCODE_DATE_LAST_INSERTED] ON [vws_prod].[VWSDEST].[NICE_HOSPITAL_GM_BASE] ([GMCODE], [DATE_LAST_INSERTED]) INCLUDE ([DATE_OF_REPORT], [NEW_DATE_OF_REPORT_UNIX], [OLD_DATE_OF_REPORT_UNIX], [OLD_VALUE_REPORTED], [DIFFERENCE_REPORTED])	0,345701042421014	0,345701042421014
-- 5	282268,8	2021-01-26 09:56:29.903	534942,01	CREATE INDEX [IX_NICE_HOSPITAL_GM_BASE_GMCODE] ON [vws_prod].[VWSDEST].[NICE_HOSPITAL_GM_BASE] ([GMCODE])	0,345248976794833	0,690950019215847
-- 5	41307,84	2021-01-26 09:56:32.590	252673,21	CREATE INDEX [IX_GGD_TESTED_PEOPLE_VR_REGION_CODE_DATE_LAST_INSERTED] ON [vws_prod].[VWSDEST].[GGD_TESTED_PEOPLE_VR] ([REGION_CODE], [DATE_LAST_INSERTED]) INCLUDE ([DATE_OF_STATISTICS])	0,0505244982569971	0,741474517472844
-- 5	40128,48	2021-01-26 09:56:32.590	211365,37	CREATE INDEX [IX_GGD_TESTED_PEOPLE_VR_REGION_CODE] ON [vws_prod].[VWSDEST].[GGD_TESTED_PEOPLE_VR] ([REGION_CODE]) INCLUDE ([DATE_OF_STATISTICS], [DATE_LAST_INSERTED])	0,0490819979407285	0,790556515413573
--
-- Intuitively with a canonical 80/20 just by creating these indexes (the supposed 20% of all the indexes the server has learned of while serving queries) we take care of the basically all of the work (the famous 80%).
-- 80% is given from the 0.8 in the query of the last filter.
-- The idea of this approach is to guide the choice on the index creation:
-- - creating "all possible" indexes is a bad idea, because most of them yield no performance increase - but creating multiple indexes for the same table gives much overhead
-- - creating too few of them does not help of course, but the question is which ones?
--
-- A similar approach to implement could be: create only the indexes whose columns yield the highest information gain overall. In particular the bit entropy of a single column may be approximated like:
-- SELECT LOG(COUNT(DISTINCT [RANK_PERCENTAGE_IN_SECURITY_REGION]), 2) FROM [vws_prod].[VWSDEST].[SEWER_BASE]
-- 1,58496250072116
-- where the higher the more informative the column, so the better it splits the variable (which is just: more different values, more partitions).
-- Informally we may say that encoding the RANK_PERCENTAGE_IN_SECURITY_REGION variable takes at least about one bit and a half (this is an approximation as we don't bring in the frequencies, a uniform distribution is assumed).
--
-- Yet another approach is to focus on creation timestamps such as DATE_LAST_INSERTED, which are by definition the most informative fields as they differ per batch only, and are no measurements.
-- Computing the entropy as above on this field for a few tables yields the highest scores.
--
-- There are even more options of course, like manual inspection. Or we just "know" that some indexes can yield better speedups than others.
--
-- Finally: for a given ingestion, shall we index on stage, inter or dest? While from stage to inter we have to look at a lot of data, it is from dest to the views that we have to access possible many times;
-- for example for a city-level statistic we are accessing as many times as there are cities. This script scans through the whole schema.

-- Run on production, then copy the resulting statements in the SQL code units to create the indexes (the script itself does not create any).
-- Important: index stats are collected since the server has started, so avoiding restarts guarantees a long and consistent history.
-- Index evaluation may take place monthly. If the query returns many rows we might just choose not to do anything, but have a look at the energy scores too.
-- Credits: SQL Authority (https://blog.sqlauthority.com/2011/01/03/sql-server-2008-missing-index-script-download/)

CREATE OR ALTER VIEW [VWSMISC].[V_INDEX_HELPER_8020] AS
    WITH BASE_CTE AS (
        SELECT X.DatabaseID, X.Avg_Estimated_Impact, X.Last_User_Seek, ROUND(SUM(X.Avg_Estimated_Impact) OVER(ORDER BY X.Avg_Estimated_Impact ROWS 
                BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS Cum_Avg_Estimated_Impact, X.Create_Statement
        FROM (
            SELECT
            dm_mid.database_id AS DatabaseID,
            ROUND(dm_migs.avg_user_impact*(dm_migs.user_seeks+dm_migs.user_scans), 2) Avg_Estimated_Impact,
            dm_migs.last_user_seek AS Last_User_Seek, 
            OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) AS [TableName],
            'CREATE NONCLUSTERED INDEX [IX_' + OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) + '_'
            + REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns,''),', ','_'),'[',''),']','') 
            + CASE
            WHEN dm_mid.equality_columns IS NOT NULL
            AND dm_mid.inequality_columns IS NOT NULL THEN '_'
            ELSE ''
            END
            + REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns,''),', ','_'),'[',''),']','')
            + ']'
            + ' ON ' + dm_mid.statement
            + ' (' + ISNULL (dm_mid.equality_columns,'')
            + CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns 
            IS NOT NULL THEN ',' ELSE
            '' END
            + ISNULL (dm_mid.inequality_columns, '')
            + ')'
            + ISNULL (' INCLUDE (' + dm_mid.included_columns + ')', '') AS Create_Statement
            FROM sys.dm_db_missing_index_groups dm_mig
            INNER JOIN sys.dm_db_missing_index_group_stats dm_migs
            ON dm_migs.group_handle = dm_mig.index_group_handle
            INNER JOIN sys.dm_db_missing_index_details dm_mid
            ON dm_mig.index_handle = dm_mid.index_handle
            WHERE dm_mid.database_ID = DB_ID()
        ) X
    ),
    MAX_CTE AS ( SELECT MAX(Cum_Avg_Estimated_Impact) AS Max_Cum_Avg_Estimated_Impact FROM BASE_CTE )
    SELECT * FROM (
        SELECT *, ROUND(SUM(T.Energy) OVER(ORDER BY T.Energy DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS Energy_Total FROM (
            SELECT *, ROUND(Avg_Estimated_Impact/(SELECT * FROM MAX_CTE), 2) AS Energy
            FROM BASE_CTE
            ) T
        ) U
    WHERE U.Energy_Total < 0.8
