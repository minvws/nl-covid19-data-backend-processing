CREATE   VIEW [VWSDEST].[V_SEWER_MEASUREMENTS_PER_REGION] AS
 
   WITH Sel As (
   SELECT
         REGIO_CODE                                               AS VRCODE
         ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_MEASUREMENT])         AS DATE_UNIX
         ,CAST(ROUND([AVERAGE_RNA_FLOW_PER_100000],0) as INT)      AS [AVERAGE]
         ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)         AS [DATE_OF_INSERTION_UNIX]
         ,CASE WHEN dbo.WEEK_START(dbo.CONVERT_UNIX_TO_DATETIME(WEEK_UNIX)) < dateadd(day, -14, dbo.WEEK_START(DATE_LAST_INSERTED)) THEN 'true' ELSE 'false' END AS data_is_outdated
         ,Date_Last_inserted
     FROM [VWSDEST].[SEWER_PROLONGATED]
     WHERE DatePart(WeekDay,[DATE_LAST_INSERTED]) IN(3, 4, 6)
       AND REGIO_CODE <> 'NL'
 
   )
   SELECT VRCODE
         , DATE_UNIX
         , [AVERAGE]
         , data_is_outdated
         , [DATE_OF_INSERTION_UNIX]
     FROM Sel
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM Sel)