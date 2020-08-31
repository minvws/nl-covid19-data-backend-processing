-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.


CREATE OR ALTER FUNCTION [dbo].[CONVERT_DATETIME_TO_UNIX] (@input DATETIME)
RETURNS BIGINT
AS BEGIN
    DECLARE @work BIGINT
    set @work = DATEDIFF(SECOND,{d '1970-01-01'}, convert(datetime, @input, 101))
    RETURN @work
END
GO