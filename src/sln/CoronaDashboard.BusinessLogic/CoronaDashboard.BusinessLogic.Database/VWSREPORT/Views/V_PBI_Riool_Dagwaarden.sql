CREATE   VIEW [VWSREPORT].[V_PBI_Riool_Dagwaarden]
 AS
 -- Riool gegevens      
     SELECT
         CAST([DATE_MEASUREMENT] as date)                                        AS [Datum]
         ,CAST(dbo.CONVERT_UNIX_TO_DATETIME([WEEK_UNIX]) as date)	            AS [Week start]
         ,CAST(dbo.WEEK_END(dbo.CONVERT_UNIX_TO_DATETIME([WEEK_UNIX])) as date)  AS [Week einde]
         ,CAST([DATE_LAST_INSERTED] as date)                                     AS [Update datum]
         ,[AVERAGE_RNA_FLOW_PER_100000]							                AS [RNA flow per 100K]
         ,[REGION_COVERED_INHABITANTS]								            AS [Inwoners regio covered]
         ,[RNA_FLOW_PER_100000_PER_RWZI_ORIGINAL]                                AS [RNA flow per 100K dagwaarde]
   FROM [VWSDEST].[SEWER_PROLONGATED]
   WHERE
 	[DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[SEWER_PROLONGATED])
 	and
 	REGIO_CODE = 'NL'