-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER FUNCTION [dbo].[CONVERT_ISO_WEEK_TO_UNIX] (@year INT, @week INT)
RETURNS BIGINT
AS BEGIN
    DECLARE @result BIGINT
    set @result=[dbo].[CONVERT_DATETIME_TO_UNIX]([dbo].[CONVERT_ISO_WEEK_TO_DATETIME](@year, @week))
    RETURN @result
END
GO