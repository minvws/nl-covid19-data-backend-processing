﻿
CREATE   VIEW  [DATATINO_ORCHESTRATOR_1].[V_PROCESSES] AS

SELECT 
       T0.[ID]                  AS PROCESS_ID
      ,T4.NAME                  AS PROCESS_NAME
      ,T0.[WORKFLOW_ID]
      ,T2.NAME                  AS WORKFLOW_NAME
      ,T0.[SOURCE_ID]
      ,T3.NAME                  AS SOURCE_NAME
      ,T3.SOURCE_CONTENT
      ,T3.SOURCE_COLUMNS
      ,T3.TARGET_COLUMNS
      ,T3.TARGET_NAME
      ,T3.SOURCE_TYPE_ID
      ,T6.NAME                  AS SOURCE_TYPE_NAME
      ,T3.DELIMITER_TYPE_ID
      ,T8.NAME                  AS DELIMITER_TYPE
      ,T3.SP_ID
      ,T7.NAME                  AS SP_NAME

      ,T0.[DATAFLOW_ID]
    --   ,T0.[DATAFLOW_TYPE_ID]
    --   ,T5.NAME                  AS DATAFLOW_TYPE_NAME
      ,T0.[SCHEDULE]
      ,T0.[NEXT_RUN]
      ,T0.[LAST_RUN]
      ,T0.[ACTIVE]
  FROM [DATATINO_ORCHESTRATOR_1].[PROCESSES] AS T0
  LEFT JOIN [DATATINO_ORCHESTRATOR_1].[WORKFLOWS]           AS T1 ON T0.WORKFLOW_ID = T1.ID
  LEFT JOIN [DATATINO_ORCHESTRATOR_1].[DATAFLOWS]           AS T2 ON T2.ID = T1.DATAFLOW_ID
  LEFT JOIN [DATATINO_ORCHESTRATOR_1].[SOURCES]             AS T3 ON T3.ID = T0.SOURCE_ID
  LEFT JOIN [DATATINO_ORCHESTRATOR_1].[DATAFLOWS]           AS T4 ON T4.ID = T0.DATAFLOW_ID
  LEFT JOIN [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES]      AS T5 ON T5.ID = T0.DATAFLOW_TYPE_ID
  LEFT JOIN [DATATINO_ORCHESTRATOR_1].[SOURCE_TYPES]        AS T6 ON T6.ID = T3.SOURCE_TYPE_ID
  LEFT JOIN [DATATINO_ORCHESTRATOR_1].[SECURITY_PROFILES]   AS T7 ON T7.ID = T3.SP_ID
  LEFT JOIN [DATATINO_ORCHESTRATOR_1].[DELIMITER_TYPES]     AS T8 ON T8.ID = T3.DELIMITER_TYPE_ID