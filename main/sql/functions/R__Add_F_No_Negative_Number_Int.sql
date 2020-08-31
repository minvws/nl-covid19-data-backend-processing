-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- If the number is lower than zero, make it zero
CREATE OR ALTER FUNCTION DBO.NO_NEGATIVE_NUMBER_I (@input INT)
RETURNS INT
AS BEGIN
    DECLARE @Work INT

    SET @Work = @Input
    -- if the value was null keep it at null
    set @Work = (CASE WHEN @work IS NULL THEN NULL
    ELSE
        (SELECT CASE WHEN @work > 0 THEN @work ELSE 0 END)
    END)
    RETURN @work
END