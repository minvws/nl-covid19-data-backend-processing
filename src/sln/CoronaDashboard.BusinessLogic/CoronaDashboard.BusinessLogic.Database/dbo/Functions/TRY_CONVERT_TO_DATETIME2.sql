CREATE   FUNCTION [DBO].[TRY_CONVERT_TO_DATETIME2](@input [VARCHAR](10))
RETURNS [DATETIME]
AS BEGIN
    DECLARE @dt DATETIME;

    SET @dt = CASE 
        WHEN TRY_CONVERT(DATE, @input, 126) IS NOT NULL THEN CONVERT(DATE, @input, 126)
        WHEN TRY_CONVERT(DATE, @input, 120) IS NOT NULL THEN CONVERT(DATE, @input, 120)
        WHEN TRY_CONVERT(DATE, @input, 105) IS NOT NULL THEN CONVERT(DATE, @input, 105)
        ELSE CONVERT(DATE, @input)
    END;


    -- IF @dt IS NULL
    -- BEGIN
    --     SET @dt = TRY_CONVERT(DATETIME, @input, 120);
    -- END

    -- IF @dt IS NULL
    -- BEGIN
    --     SET @dt = TRY_CONVERT(DATETIME, @input, 126);
    -- END

    RETURN @dt;
END;