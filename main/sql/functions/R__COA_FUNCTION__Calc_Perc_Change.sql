-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER FUNCTION [dbo].[CALC_PERC_CHANGE] (@new BIGINT, @old BIGINT)
RETURNS FLOAT
AS BEGIN
    DECLARE @res FLOAT
    -- Return null if div through 0
    set @res = 1.0*(@new-@old)/NULLIF(@old, 0)
    RETURN @res
END
GO