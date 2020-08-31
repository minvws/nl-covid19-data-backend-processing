-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.


/*
  We report weeks from Monday to Sunday. The default Sql Server setting has a start day of Sunday. 
  In order to work around this fact, without having to alter the default settings, the below function will do the exact same thing.

  Ex.
    2020-02-23 => Sunday
        * Normally, this would then become 2020-02-24, when you try to find the Monday.
        * Now it becomes 2020-02-17, which is the Monday of that given week.
*/
CREATE OR ALTER FUNCTION [dbo].[WEEK_START_FROM_WEEKNUMBER] (@input INT)
RETURNS DATETIME
AS BEGIN
    DECLARE @work DATETIME
    SET @work = convert(datetime, DATEADD(day, 6, dateadd(week,@input-1, DATEADD(wk, DATEDIFF(wk,-1,DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)), 0))), 101)
    set @work = DATEADD(week, DATEDIFF(day, 0, @work)/7, 0) 
    RETURN @work
END
GO