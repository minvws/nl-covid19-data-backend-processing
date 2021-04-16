-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE [dbo].[SP_CBS_DECEASED_VR_FORECAST_INTER]
AS
BEGIN
    INSERT INTO VWSINTER.CBS_DECEASED_VR_FORECAST (
    [YEAR] ,
    [WEEK] ,
    [DECEASED_FORECAST] ,
    [DECEASED_FORECAST_LOW] ,
    [DECEASED_FORECAST_HIGH] ,
    [VRNAME] ,
    [VRCODE] 
    )
    SELECT
    CAST(SUBSTRING([WEEK], 1,4) AS INT) as [YEAR] ,
    CAST(SUBSTRING([WEEK], 11,2) AS INT) as [WEEK] ,
    [SEIZOENSPATROON MET MARGES] ,
    [ONDERGRENS] ,
    [BOVENGRENS] ,
    [VR NAAM] ,
    [VR CODE] 
    FROM 
        VWSSTAGE.CBS_DECEASED_VR_FORECAST
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                                  FROM VWSSTAGE.CBS_DECEASED_VR_FORECAST)
END;

