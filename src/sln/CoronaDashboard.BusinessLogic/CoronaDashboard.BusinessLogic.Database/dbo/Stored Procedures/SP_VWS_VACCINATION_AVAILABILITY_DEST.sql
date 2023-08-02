-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Attention: if new vaccine providers come this query must be edited. Dynamic SQL is rather cumbersome and the frontend expects a fixed
-- set of providers anyway.
CREATE   PROCEDURE [dbo].[SP_VWS_VACCINATION_AVAILABILITY_DEST]
AS
BEGIN

WITH BASE_CTE AS
(
    SELECT VACCIN_NAME
        , DATE_DELIVERY
        , SUM(AMOUNT_DELIVERY) AS [AMOUNT_DELIVERY]
    FROM VWSINTER.VWS_VACCINATION_AVAILABILITY
                        -- get the latest update
            WHERE VALID_FROM = (SELECT MAX(VALID_FROM) FROM VWSINTER.VWS_VACCINATION_AVAILABILITY)
              AND DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.VWS_VACCINATION_AVAILABILITY)
        GROUP BY VACCIN_NAME, DATE_DELIVERY
) 
, PIVOT_CTE AS
(
    SELECT [AstraZeneca], [BioNTech/Pfizer], [CureVac], [Janssen], [Moderna], [Sanofi], [DATE_DELIVERY]  
    FROM   
    (
        SELECT VACCIN_NAME
            , DATE_DELIVERY
            , AMOUNT_DELIVERY   
        FROM BASE_CTE
    ) p  
    PIVOT  
    (  
        SUM (AMOUNT_DELIVERY)  
        FOR VACCIN_NAME IN  
            ( [AstraZeneca],[BioNTech/Pfizer],[CureVac],[Janssen],[Moderna],[Sanofi] )  
    ) AS pvt  
    --ORDER BY DATE_DELIVERY
)
INSERT INTO VWSDEST.VWS_VACCINATION_AVAILABILITY (
    [DATE_START],
    [DATE_END],
    [DATE_START_UNIX],
    [DATE_END_UNIX],
    [AstraZeneca],
    [BioNTech/Pfizer],
    [CureVac],
    [Janssen],
    [Moderna],
    [Sanofi]
)
SELECT 
      [DATE_DELIVERY] AS DATE_START
    , DATEADD( day,6,[DATE_DELIVERY] ) AS DATE_END
    , dbo.CONVERT_DATETIME_TO_UNIX([DATE_DELIVERY]) AS DATE_START_UNIX
    , dbo.CONVERT_DATETIME_TO_UNIX( DATEADD( day,6,[DATE_DELIVERY] ) ) AS DATE_END_UNIX
    , ISNULL([AstraZeneca]        ,0) AS   [AstraZeneca]
    , ISNULL([BioNTech/Pfizer]    ,0) AS   [BioNTech/Pfizer]
    , ISNULL([CureVac]            ,0) AS   [CureVac]
    , ISNULL([Janssen]            ,0) AS   [Janssen]
    , ISNULL([Moderna]            ,0) AS   [Moderna]
    , ISNULL([Sanofi]             ,0) AS   [Sanofi] 
  FROM PIVOT_CTE
END;