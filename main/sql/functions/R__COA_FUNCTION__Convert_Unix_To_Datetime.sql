-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER FUNCTION [dbo].[CONVERT_UNIX_TO_DATETIME] (@input BIGINT)
RETURNS DATETIME
AS BEGIN
    DECLARE @res DATETIME
    set @res = DATEADD(S, @input, '1970-01-01')
    RETURN @res
END
GO