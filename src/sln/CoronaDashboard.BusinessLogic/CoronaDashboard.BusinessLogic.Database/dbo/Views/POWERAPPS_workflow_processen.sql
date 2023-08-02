/****** Script for SelectTopNRows command from SSMS  ******/
Create    VIEW [dbo].[POWERAPPS_workflow_processen] AS

SELECT 
      t1.[PROCESS_NAME]
      ,t1.[DESCRIPTION]
      ,t2.[WORKFLOW_NAME]
      ,t1.[WORKFLOW_ID]
  FROM [DATATINO_ORCHESTRATOR].[PROCESSES] t1
  Left Join [DATATINO_ORCHESTRATOR].[WORKFLOWS] t2
  on t1.WORKFLOW_ID = t2.ID