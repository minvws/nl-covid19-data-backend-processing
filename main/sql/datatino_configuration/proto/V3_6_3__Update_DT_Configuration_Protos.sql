DELETE FROM [DATATINO_PROTO].[PROTO_CONFIGURATIONS]
WHERE CONSTRAINT_VALUE NOT in (select GMCODE 
                    FROM  VWSSTATIC.GMCODES_WITH_SEWER_MEASUREMENTS) 
                    AND ITEM_NAME = 'results_per_sewer_installation_per_municipality';