CREATE   VIEW [VWSDEST].[V_SEWER_MEASUREMENTS]
 AS
   WITH Sel As (
       SELECT 
           dbo.CONVERT_DATETIME_TO_UNIX([DATE_MEASUREMENT]) AS DATE_UNIX
           , CAST(round([AVERAGE_RNA_FLOW_PER_100000],0) as INT)          AS [AVERAGE]
           ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS [DATE_OF_INSERTION_UNIX]
           ,Regio_Code
           ,date_Last_Inserted
       FROM [VWSDEST].[SEWER_PROLONGATED]
       -- First filter on Wednesdays
       WHERE DatePart(WeekDay, Date_Last_Inserted) IN(3, 4, 6)
   )
   SELECT 
         DATE_UNIX
         ,[AVERAGE]
         ,[DATE_OF_INSERTION_UNIX]
     FROM Sel
     -- Then filter on the newest dataset
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM Sel)
       AND REGIO_CODE = 'NL'