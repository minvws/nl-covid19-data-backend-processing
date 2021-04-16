-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
/*
 This functions returns the first day of the iso week. 
*/

CREATE OR ALTER  FUNCTION [dbo].[CONVERT_ISO_WEEK_TO_DATETIME] (@year INT, @week INT)
RETURNS DATETIME
AS BEGIN
    DECLARE @result DATETIME
    -- 01/04 - 4th of January - to identify week 01 (see https://en.wikipedia.org/wiki/ISO_8601#Week_dates)
    SET @result = DATEADD(wk,DATEDIFF(wk,0,DATEFROMPARTS(@year,1,4)),0)+((@week-1)*7)
    RETURN @result
END
GO
