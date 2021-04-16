-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER FUNCTION [dbo].[CONVERT_DATETIME_TO_ISO_WEEKNUMBER] (@input DATETIME)
RETURNS INT
AS BEGIN
    DECLARE @res INT
    set @res = DATEPART(ISO_WEEK, @input)
    RETURN @res
END
GO