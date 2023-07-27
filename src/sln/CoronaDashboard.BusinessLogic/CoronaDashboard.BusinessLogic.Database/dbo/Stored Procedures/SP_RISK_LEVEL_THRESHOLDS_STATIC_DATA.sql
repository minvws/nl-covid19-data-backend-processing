-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   PROCEDURE [dbo].[SP_RISK_LEVEL_THRESHOLDS_STATIC_DATA]
AS
BEGIN

    INSERT INTO [VWSSTATIC].RISK_LEVEL_THRESHOLDS (
         RISK_LEVEL_1  
        ,RISK_LEVEL_2  
        ,RISK_LEVEL_3  
        ,IC_LOWER      
        ,IC_UPPER      
        ,HOSP_LOWER    
        ,HOSP_UPPER    
        ,[GELDIG VANAF]
      )

    SELECT * FROM (
        SELECT    
            -- Risk levels
             LAG([OMSCHRIJVING RISICONIVEAU],1) OVER (ORDER BY [RISICO NIVEAU]  ASC)    AS RISK_LEVEL_1
            ,[OMSCHRIJVING RISICONIVEAU]                                                AS RISK_LEVEL_2
            ,LAG([OMSCHRIJVING RISICONIVEAU],1) OVER (ORDER BY [RISICO NIVEAU]  DESC)   AS RISK_LEVEL_3

            --IC Thresholds
            ,CASE WHEN CHARINDEX('-',[7 DAAGS GEMIDDELDE IC OPNAMES]) > 0 
                    THEN LEFT([7 DAAGS GEMIDDELDE IC OPNAMES], CHARINDEX('-',[7 DAAGS GEMIDDELDE IC OPNAMES])-1)
                ELSE NULL
                END AS IC_LOWER
            ,CASE WHEN CHARINDEX('-',[7 DAAGS GEMIDDELDE IC OPNAMES]) > 0 
                    THEN RIGHT([7 DAAGS GEMIDDELDE IC OPNAMES], LEN([7 DAAGS GEMIDDELDE IC OPNAMES]) - CHARINDEX('-',[7 DAAGS GEMIDDELDE IC OPNAMES]))
                ELSE NULL
                END AS IC_UPPER

            --Hospital Thresholds
            ,CASE WHEN CHARINDEX('-',[7 DAAGS GEMIDDELDE ZIEKENHUISOPNAMES]) > 0 
                    THEN LEFT([7 DAAGS GEMIDDELDE ZIEKENHUISOPNAMES], CHARINDEX('-',[7 DAAGS GEMIDDELDE ZIEKENHUISOPNAMES])-1)
                ELSE NULL
                END AS HOSP_LOWER
            ,CASE WHEN CHARINDEX('-',[7 DAAGS GEMIDDELDE IC OPNAMES]) > 0 
                    THEN RIGHT([7 DAAGS GEMIDDELDE ZIEKENHUISOPNAMES], LEN([7 DAAGS GEMIDDELDE ZIEKENHUISOPNAMES]) - CHARINDEX('-',[7 DAAGS GEMIDDELDE ZIEKENHUISOPNAMES]))
                ELSE NULL
                END AS HOSP_UPPER

            --Validity
            ,CONVERT(datetime,[GELDIG VANAF],103)     AS [GELDIG VANAF]
            FROM [VWSSTAGE].RISK_LEVEL_THRESHOLDS
            WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSSTAGE].RISK_LEVEL_THRESHOLDS )
    ) AS T0
        WHERE IC_UPPER IS NOT NULL AND IC_LOWER IS NOT NULL -- Add all logic to middle level row

END