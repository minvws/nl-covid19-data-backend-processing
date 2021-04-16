-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE [dbo].[SP_INHABITANTS_PER_REGION_STATIC]
AS
BEGIN
    INSERT INTO VWSSTATIC.CBS_INHABITANTS_PER_MUNICIPALITY
    ([VRCODE], [GMCODE], [INHABITANTS])
    SELECT
        [CODE_42],
        [CODE_1],
        [INWONERTAL_50]
    FROM VWSSTAGE.CBS_INHABITANTS_PER_MUNICIPALITY
END;