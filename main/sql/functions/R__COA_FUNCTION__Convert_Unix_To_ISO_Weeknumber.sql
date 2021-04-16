-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER FUNCTION [dbo].[CONVERT_UNIX_TO_ISO_WEEKNUMBER] (@input BIGINT)
RETURNS INT
AS BEGIN
    DECLARE @res INT
    set @res = dbo.CONVERT_DATETIME_TO_ISO_WEEKNUMBER(dbo.CONVERT_UNIX_TO_DATETIME(@input))
    RETURN @res
END
GO