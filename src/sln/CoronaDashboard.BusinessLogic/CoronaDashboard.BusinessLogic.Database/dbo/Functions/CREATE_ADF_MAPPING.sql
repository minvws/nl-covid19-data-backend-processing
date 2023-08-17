CREATE   FUNCTION [dbo].[CREATE_ADF_MAPPING](@source_columns NVARCHAR(MAX), @sink_columns NVARCHAR(MAX))
 RETURNS NVARCHAR(MAX)
 AS
 BEGIN
     DECLARE @result NVARCHAR(MAX)
     ;WITH CTE_SOURCE AS (
         SELECT VALUE, ORDINAL  FROM STRING_SPLIT(@source_columns, '|', 1)
     ),
     CTE_TARGET AS (
         SELECT VALUE, ORDINAL  FROM STRING_SPLIT(@sink_columns, '|', 1)
     
     ),
     CTE_COMBINED AS (
         SELECT '{"source":{"name":"' + cte_source.value + '"},"sink":{"name":"' + cte_target.value + '"}}' AS setting 
         FROM CTE_SOURCE
         INNER JOIN CTE_TARGET ON cte_source.ordinal = cte_target.ordinal
     )
     SELECT @result = '{"type":"TabularTranslator","mappings":[' +  STRING_AGG(setting, ',') + ']}'
     FROM CTE_COMBINED
     RETURN @result
 END