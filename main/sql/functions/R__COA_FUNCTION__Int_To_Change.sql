-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER FUNCTION [dbo].[INT_TO_CHANGE] (@val INT)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN
        CASE 
            WHEN @val > 0 THEN 'up'
            WHEN @val < 0 THEN 'down'
            WHEN @val = 0  THEN 'equal'
            ELSE NULL
        END 
END