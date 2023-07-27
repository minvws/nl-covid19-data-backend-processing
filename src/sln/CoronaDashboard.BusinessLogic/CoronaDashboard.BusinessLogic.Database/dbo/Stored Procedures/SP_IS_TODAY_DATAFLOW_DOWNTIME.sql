CREATE   PROCEDURE [dbo].[SP_IS_TODAY_DATAFLOW_DOWNTIME]
                AS
                BEGIN
                    IF EXISTS(SELECT * FROM [DATATINO_ORCHESTRATOR_1].[DATAFLOW_DOWNTIME] WHERE CONVERT (date, DATETIME) = CONVERT (date, GETDATE()))
                        RETURN 1
                    ELSE 
                        RETURN 0
                END