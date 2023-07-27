CREATE   VIEW VWSREPORT.V_DateLineage_edges
AS


        -- Stored procedures
        WITH SPs AS (
        select 
                name AS [procedure_name]
                ,referenced_schema_name + '.' + referenced_entity_name AS [reference]
                ,CASE
                        WHEN is_updated = 1 THEN 'INSERT'
                        ELSE 'SELECT'
                END AS [reference_use]
        --INTO #SPs
        from sys.procedures as p
        cross apply sys.dm_sql_referenced_entities(CONCAT(SCHEMA_NAME(p.schema_id), '.', p.name), 'OBJECT') ref
        WHERE  ref.referenced_minor_id = 0 AND referenced_entity_name != 'CONVERT_DATETIME_TO_UNIX'
        ),
        Views AS (

        -- Views
        --DROP TABLE IF EXISTS #VIEWs
        select 
                SCHEMA_NAME(v.schema_id) + '.' + name                   AS [view_name]
                ,referenced_schema_name + '.' + referenced_entity_name  AS [reference]
        
        
        --INTO #VIEWs
        from sys.views as v
        cross apply sys.dm_sql_referenced_entities(CONCAT(SCHEMA_NAME(v.schema_id), '.', v.name), 'OBJECT') ref
        WHERE  ref.referenced_minor_id = 0 AND referenced_schema_name != 'dbo'
        )


        SELECT 

                [NODE1_CATEGORY]
                ,[NODE1]
                ,[NODE2_CATEGORY]
                ,[NODE2]

        FROM (
        -- Sources Load
        SELECT 
                LOCATION_TYPES.NAME                                     AS [NODE1_CATEGORY]
                ,SOURCE                                                 AS [NODE1]
                ,'Table'                                                AS [NODE2_CATEGORY]
                ,UPPER(REPLACE(REPLACE(TARGET_NAME, '[',''),']',''))    AS [NODE2]

        FROM 
                DATATINO_ORCHESTRATOR.SOURCES SOURCES
        LEFT JOIN
                DATATINO_ORCHESTRATOR.LOCATION_TYPES ON
                LOCATION_TYPES.ID = SOURCES.LOCATION_TYPE_ID
        WHERE
                SOURCE_TYPE_ID != 1 -- Not Stored procedure

        UNION
        -- Procedures SELECT
        SELECT 
                'Table'                                                 AS [NODE1_CATEGORY]
                ,UPPER(SP_SELECT.reference)                             AS [NODE1]
                ,'StoredProcedure'                                      AS [NODE2_CATEGORY]
                ,UPPER(SP_SELECT.[procedure_name])                      AS [NODE2]
                
        FROM
                SPs SP_SELECT        
        WHERE
                SP_SELECT.reference_use = 'SELECT'
        
        UNION
        -- Procedures INSERT
        SELECT 
                 'StoredProcedure'                                      AS [NODE1_CATEGORY]
                ,UPPER(SP_INSERT.[procedure_name])                      AS [NODE1]
                ,'Table'                                                AS [NODE2_CATEGORY]
                ,UPPER(SP_INSERT.reference)                             AS [NODE2]
                
        FROM
                SPs SP_INSERT      
        WHERE
                SP_INSERT.reference_use = 'INSERT'
        UNION
        -- Views
        SELECT 
                'Table'                                                 AS [NODE1_CATEGORY]
                ,UPPER(reference)                                       AS [NODE1]
                ,CASE 
                        WHEN VIEW_NAME LIKE 'VWSREPORT%PBI%' 
                                THEN 'ReportView' 
                                ELSE 'View' 
                END                                                     AS [NODE2_CATEGORY]
                ,UPPER(view_name)                                       AS [NODE2]
                
        FROM VIEWs
        
        UNION
        SELECT 
                CASE 
                        WHEN VIEW_NAME LIKE 'VWSREPORT%PBI%' 
                                THEN 'ReportView' 
                                ELSE 'View' 
                END                                                     AS [NODE1_CATEGORY]
                ,UPPER(REPLACE(REPLACE(VIEW_NAME, '[', ''),']', ''))    AS [NODE1]
                ,'Proto'                                                AS [NODE2_CATEGORY]
                ,ITEM_NAME                                              AS [NODE2]
        FROM
                DATATINO_PROTO.V_PROTO_CONFIGURATIONS

		
        -- UNION
        -- SELECT 
        --         'Proto'                                                  AS [NODE1_CATEGORY]
        --         ,ITEM_NAME                                               AS [NODE1]
        --         ,'Proto'                                                 AS [NODE2_CATEGORY]
        --         ,LEFT(PROTO_NAME,2)                                       AS [NODE2]
				
        -- FROM
        --         DATATINO_PROTO.V_PROTO_CONFIGURATIONS
        ) combined