CREATE   FUNCTION [dbo].[WEEK_START_ISO] (@input DATETIME)
 RETURNS DATETIME
 AS BEGIN
     DECLARE @work DATETIME
     SET @work = @input
     SET @work = dateadd(day, 1 - datepart(weekday, @work), @work) --Most recent sunday
     RETURN @work
 END