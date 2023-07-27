CREATE   FUNCTION [dbo].[GetDateFromISOweek] (@Input VARCHAR(10))  
RETURNS DATETIME  
WITH EXECUTE AS CALLER  
AS  
BEGIN  
    DECLARE @YearNum CHAR(4) 
    DECLARE @WeekNum VARCHAR(2)
    DECLARE @FirstDay datetime
    /* 
        The input format is 'yyyyWww', e.g. 2010W01. 
        @YearNum = 2010
        @WeekNum = 01
        @FirstDay = For a given week, the start date of that week is calculated.
        Return: A datetime format.
    */

    SET @YearNum = cast(SUBSTRING(@Input,0,CHARINDEX('W',@Input,0)) as int)
    SET @WeekNum = SUBSTRING(@Input,CHARINDEX('W',@Input,0)+2,LEN(@Input))
    SET @FirstDay=DATEADD(DAY, (@@DATEFIRST - DATEPART(WEEKDAY, DATEADD(YEAR, @YearNum - 1900, 0)) +  (8 - @@DATEFIRST) * 2) % 7, DATEADD(YEAR, @YearNum - 1900, 0))-1

    RETURN(DATEADD(wk, DATEDIFF(wk, 6, '1/1/' + @YearNum) + (@WeekNum-case when DATEDIFF ( day ,  convert(datetime,'01/01/'+ @YearNum),@FirstDay )>=3 then 1 else 0 end), 7));
END;