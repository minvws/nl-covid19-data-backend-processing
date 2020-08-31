-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.


CREATE OR ALTER FUNCTION [dbo].[NORMALIZATION] (@input FLOAT)
RETURNS FLOAT
AS BEGIN
    DECLARE @NORMALIZATION FLOAT;
    SET @NORMALIZATION = @input /100000.0;
    RETURN @NORMALIZATION
END
GO