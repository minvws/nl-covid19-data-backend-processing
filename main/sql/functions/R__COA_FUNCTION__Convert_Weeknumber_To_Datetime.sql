-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER FUNCTION [dbo].[CONVERT_WEEKNUMBER_TO_DATETIME] (@year VARCHAR(4), @week VARCHAR(2))
RETURNS DATETIME
AS BEGIN
    DECLARE @result DATETIME

    set @result = DATEADD(wk,DATEDIFF(wk,0,'01/04/'+@year),0)+((@week-1)*7)
    RETURN @result
END