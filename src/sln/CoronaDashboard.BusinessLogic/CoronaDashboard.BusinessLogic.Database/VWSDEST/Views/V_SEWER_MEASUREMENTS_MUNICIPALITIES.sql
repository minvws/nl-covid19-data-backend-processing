﻿CREATE   VIEW [VWSDEST].[V_SEWER_MEASUREMENTS_MUNICIPALITIES] 
 AS
     SELECT 
         [DATE_START_UNIX],
         [DATE_END_UNIX],
         [GMCODE],
         [AVERAGE],
         [TOTAL_INSTALLATION_COUNT],
         [DATA_IS_OUTDATED],
         [DATE_OF_INSERTION_UNIX]
     FROM (
     SELECT
         [DATE_START_UNIX],
         [DATE_END_UNIX],
         [GMCODE],
         [AVERAGE],
         [TOTAL_INSTALLATION_COUNT],
         [DATA_IS_OUTDATED],
         [DATE_OF_INSERTION_UNIX],
         RANK() OVER (PARTITION BY [GMCODE] ORDER BY [DATE_START_UNIX] DESC) [RANKING]
     FROM [VWSDEST].[V_SEWER_MEASUREMENTS_PER_MUNICIPALITY]
     ) T1
     WHERE T1.[RANKING] = 1 AND [GMCODE] IS NOT NULL