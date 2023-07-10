

CREATE   VIEW [DATATINO_ORCHESTRATOR_1].[V_LINEAGE]
AS 


WITH VIEWS_CONFIGS_CTE AS ( 
    --Use logic from V_CONFIGURATIONS
    --Start on the protos end, retrieve all proto configs
      SELECT T0.[ID]
            ,T0.[NAME]            AS CONFIG_NAME
            ,T0.[PROTO_ID]
            ,T1.NAME              AS PROTO_NAME
            ,T0.[VIEW_ID]   
            ,T2.NAME              AS VIEW_NAME
            ,T0.[ACTIVE]
            ,CASE 
                  WHEN T1.NAME IN('GM_COLLECTION','VR_COLLECTION','IN_COLLECTION','NL') THEN T1.NAME
                  WHEN LEFT(T1.NAME,2) = 'GM' THEN 'GM'
                  WHEN LEFT(T1.NAME,2) = 'VR' THEN 'VR'
                  WHEN LEFT(T1.NAME,2) = 'IN' THEN 'IN'
                  END AS PROTO_CATEGORY
      FROM [DATATINO_PROTO_1].[CONFIGURATIONS]      AS T0
      LEFT JOIN DATATINO_PROTO_1.PROTOS             AS T1 ON T1.ID = T0.PROTO_ID
      LEFT JOIN DATATINO_PROTO_1.VIEWS              AS T2 ON T2.ID = T0.VIEW_ID 
)
,
GROUPED_VIEWS_CONFIGS_CTE AS (
    SELECT DISTINCT  --Only look at separate proto categories: no 350 lines for a single GM config due to multiple GM's
        CONFIG_NAME
        ,PROTO_CATEGORY
        ,VIEW_NAME
        ,ACTIVE
    FROM VIEWS_CONFIGS_CTE
)
,
VIEWS_SOURCES_CTE AS (
    --Determine the tables referenced in the views
      SELECT
            SCHEMA_NAME(v.schema_id)+'.'+ v.name AS VIEW_NAME
            --   ,v.*
            --   ,'|' AS [|]
            --   ,ed.*
            ,ed.referenced_schema_name+'.'+ed.referenced_entity_name AS VIEW_SOURCE

      FROM sys.views as v
      LEFT JOIN sys.sql_expression_dependencies as ed ON v.object_id = ed.referencing_id
      WHERE is_ambiguous=0 --do not consider functions
)
,
STACKED_VIEWS_SOURCES_CTE AS (
    --Views that are based on other views
    --Add NULLS in here such that views that all views have a separate line even when stacked views are joined.
    --This represents all views also having a config on their own instead of only linking to a stacked view
    SELECT 
            VIEW_NAME
           ,VIEW_SOURCE
        FROM  VIEWS_SOURCES_CTE
    UNION ALL
    SELECT 
            NULL AS VIEW_SOURCE
           ,VIEW_NAME
        FROM  VIEWS_SOURCES_CTE
)
,
SP_REFERENCED_CTE AS (
    --Determine the tables referenced in the stored procedure
    --In these sys tables no distinction is found between tables referenced with a 'FROM' or an 'INTO' clause
      SELECT 
            UPPER(SCHEMA_NAME(p.schema_id)+'.'+ p.name) AS SP_NAME
            ,ed.referenced_schema_name+'.'+ed.referenced_entity_name   AS REFERENCED_NAME
            -- ,p.*
            -- ,'|' AS [|]
            -- ,ed.*
      FROM sys.procedures as p
      LEFT JOIN sys.sql_expression_dependencies as ed ON p.object_id = ed.referencing_id
      WHERE ed.is_ambiguous = 0 --No funcitons
)
,
WORKFLOW_SOURCES_CTE AS (
    --Retrieve all sources per workflow
    SELECT 
        [SOURCE_CONTENT]
        ,T0.[NAME]        AS SOURCE_NAME
        ,T3.[NAME]        AS WORKFLOW_NAME
        ,T2.ID            AS WORKFLOW_ID
    FROM [DATATINO_ORCHESTRATOR_1].[SOURCES]            AS T0
    LEFT JOIN [DATATINO_ORCHESTRATOR_1].[PROCESSES]     AS T1 ON T1.SOURCE_ID = T0.ID 
    LEFT JOIN [DATATINO_ORCHESTRATOR_1].[WORKFLOWS]     AS T2 ON T2.ID = T1.WORKFLOW_ID
    LEFT JOIN [DATATINO_ORCHESTRATOR_1].[DATAFLOWS]     AS T3 ON T3.ID = T2.DATAFLOW_ID
    WHERE SOURCE_TYPE_ID <> 1 -- SELECT all external sources
)
,
WORKFLOWS_SP_CTE AS (
    --Get all stored procedures in a workflow
      SELECT 
            UPPER(IIF(
                  LOWER(LEFT(REPLACE(REPLACE(T0.SOURCE_CONTENT,'[',''),']',''),3)) <> 'dbo',
                        'dbo.'+REPLACE(REPLACE(T0.SOURCE_CONTENT,'[',''),']',''),
                        REPLACE(REPLACE(T0.SOURCE_CONTENT,'[',''),']','')
            )) AS SP_NAME
            ,T3.NAME AS WORKFLOW_NAME
            ,T2.ID   AS WORKFLOW_ID
      FROM [DATATINO_ORCHESTRATOR_1].[SOURCES]AS T0
      LEFT JOIN [DATATINO_ORCHESTRATOR_1].[PROCESSES]     AS T1 ON T1.SOURCE_ID = T0.ID 
      LEFT JOIN [DATATINO_ORCHESTRATOR_1].[WORKFLOWS]     AS T2 ON T2.ID = T1.WORKFLOW_ID
      LEFT JOIN [DATATINO_ORCHESTRATOR_1].[DATAFLOWS]     AS T3 ON T3.ID = T2.DATAFLOW_ID
      WHERE SOURCE_TYPE_ID =1 
)
,
TOTAL_CTE AS (
    --Combine everything
    -- Sources -> Workflows -> Stored Procedures -> Tables (later filtered only those with a view) -> Views -> Config
      SELECT 
            T0.[SOURCE_CONTENT]
            ,T0.SOURCE_NAME
            ,T0.WORKFLOW_NAME
            ,T0.WORKFLOW_ID
            ,T1.SP_NAME
            ,T2.REFERENCED_NAME AS TABLE_NAME


            ,COALESCE(T5.VIEW_NAME, T3.VIEW_NAME) AS VIEW_NAME --Look if stacked view is available, if not take other view
            -- ,T5.VIEW_NAME       AS STACKED_VIEW
            ,COALESCE(T6.CONFIG_NAME, T4.CONFIG_NAME) AS CONFIG_NAME --Look if stacked view is available, if not take other view
            ,COALESCE(T6.PROTO_CATEGORY, T4.PROTO_CATEGORY) AS PROTO_CATEGORY --Look if stacked view is available, if not take other view
            ,COALESCE(T6.ACTIVE, T4.ACTIVE) AS CONFIG_ACTIVE --Look if stacked view is available, if not take other view
      FROM WORKFLOW_SOURCES_CTE AS T0 -- Get workflows with their sources
      LEFT JOIN WORKFLOWS_SP_CTE AS T1 ON T0.WORKFLOW_ID = T1.WORKFLOW_ID -- Add Stored procedures
      LEFT JOIN SP_REFERENCED_CTE AS T2 ON T1.SP_NAME = T2.SP_NAME -- Add linked SP items (to retrieve tables from SP's)
      LEFT JOIN VIEWS_SOURCES_CTE AS T3 ON T3.VIEW_SOURCE = T2.REFERENCED_NAME -- Link views to tables
      LEFT JOIN GROUPED_VIEWS_CONFIGS_CTE AS T4 ON T4.VIEW_NAME = T3.VIEW_NAME -- Get configs on views sources

      LEFT JOIN STACKED_VIEWS_SOURCES_CTE AS T5 ON T3.VIEW_NAME = T5.VIEW_SOURCE -- Add stacked vies: views that are found on other views
      LEFT JOIN GROUPED_VIEWS_CONFIGS_CTE AS T6 ON T6.VIEW_NAME = T5.VIEW_NAME -- Get configs on stacked views

)


SELECT --*
        SOURCE_CONTENT
       ,SOURCE_NAME
       ,WORKFLOW_NAME
       ,SP_NAME
       ,TABLE_NAME
       ,VIEW_NAME
       ,CONFIG_NAME
       ,PROTO_CATEGORY
       ,CONFIG_ACTIVE

FROM TOTAL_CTE
-- All tables are returned that occur in a SP linked to a workflow
-- Many (for example stage) will not contain views
-- Some views won't have configs
-- Only existing configs remain using filter below.
WHERE CONFIG_NAME IS NOT NULL