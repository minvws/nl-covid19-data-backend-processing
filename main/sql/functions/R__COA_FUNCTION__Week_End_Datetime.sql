-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.


/*
  We report weeks from Monday to Sunday. The default Sql Server setting has a end day of Saturday. 
  In order to work around this fact, without having to alter the default settings, the below function will do the exact same thing.

  Ex.
    2020-02-23 => Sunday
        * Normally, this would then become 2020-02-29, when you try to find the end of the week.
        * Now it becomes 2020-02-23, which is the Sunday of that given week.
*/
CREATE OR ALTER FUNCTION [dbo].[WEEK_END] (@input DATETIME)
RETURNS DATETIME
AS BEGIN
    DECLARE @work DATETIME
    SET @work = @input
    set @work = DATEADD(week, DATEDIFF(day, 0, @work)/7, 6) 
    RETURN @work
END
GO