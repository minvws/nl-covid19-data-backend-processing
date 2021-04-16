-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE [dbo].[SP_CBS_DECEASED_VR_INTER]
AS
BEGIN
    INSERT INTO VWSINTER.CBS_DECEASED_VR (
    [YEAR] ,
    [WEEK] ,
    REGIOS ,
    DECEASED_ACTUAL 
    )
    SELECT
    
    CAST(SUBSTRING([PERIODEN], 1, 4) AS INT) ,
    CAST(SUBSTRING([PERIODEN], 7, 2) AS INT) ,
    REGIOS ,
    CAST(OVERLEDENEN_1 AS INT) AS DECEASED_ACTUAL
    
    FROM 
        VWSSTAGE.CBS_DECEASED_VR
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                                  FROM VWSSTAGE.CBS_DECEASED_VR)
END;