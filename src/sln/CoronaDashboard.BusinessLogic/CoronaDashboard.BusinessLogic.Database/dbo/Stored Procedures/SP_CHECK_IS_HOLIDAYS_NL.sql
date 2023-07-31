CREATE   PROCEDURE [dbo].[SP_CHECK_IS_HOLIDAYS_NL]
 AS
 BEGIN
     IF EXISTS (
         SELECT 
             [DATETIME]
         FROM [VWSSTATIC].[HOLIDAYS_NL] 
         WHERE CONVERT (DATE, [DATETIME]) = CONVERT (DATE, GETDATE())
     )
         SELECT 1 AS [IsHoliday]
     ELSE 
         SELECT 0 AS [IsHoliday]
 END