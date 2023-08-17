CREATE   PROCEDURE [dbo].[SP_ADF_IS_TODAY_DATAFLOW_DOWNTIME]
                AS
                BEGIN
                    IF EXISTS(SELECT * FROM [DATATINO_ORCHESTRATOR_1].[DATAFLOW_DOWNTIME] WHERE CONVERT (date, DATETIME) = CONVERT (date, GETDATE()))
                        SELECT 1 AS IsDown
                    ELSE 
                        SELECT 0 AS IsDown
                END