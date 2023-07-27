-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   VIEW VWSREPORT.V_PBI_HOSPITAL_NICE AS
    
    SELECT
        CAST(DATE_OF_STATISTICS as date)            AS [Datum]
        ,CAST([DATE_LAST_INSERTED] as date)         AS [Update datum]
    ,   CAST([DATE_OF_REPORT] as date)              AS [Rapportage Datum]
    ,   [MUNICIPALITY_CODE]                         AS [GemeenteCode]
    ,   REPORTED                                    AS [Gerapporteerd]
    ,   HOSPITALIZED                                AS [Ziekenhuisopnames]
    
    FROM 
       VWSINTER.[NICE_HOSPITAL]
    
    WHERE
        DATE_LAST_INSERTED=(
            SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.[NICE_HOSPITAL]
            ) 
    /*
    SELECT
        CAST(DATE_OF_STATISTICS as date)            AS [Datum]
    --,   HOSPITAL_ADMISSIONS.GM_CODE                 AS [GemeenteCode]
    ,   REPORTED                                    AS [Gerapporteerd]
    ,   HOSPITALIZED                                AS [Ziekenhuisopnames]
    ,HOSPITALIZED_7D_AVG                            AS [Ziekenhuisopnames (7D gem)]
    FROM 
       VWSDEST.NICE_HOSPITAL_NL HOSPITAL_ADMISSIONS
    
    WHERE
        DATE_LAST_INSERTED=(
            SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.NICE_HOSPITAL_NL
            )   
    */
    -- LEFT JOIN          
    --     [VWSDEST].[INTENSIVE_CARE_ADMISSIONS] IC_ADMISSIONS ON
    --     IC_ADMISSIONS.DATE_LAST_INSERTED=(
    --         SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[NICE_HOSPITAL_GM]
    --         ) AND
    --         IC_ADMISSIONS.GM_CODE = HOSPITAL_ADMISSIONS.GM_CODE AND
    --         CAST(IC_ADMISSIONS.DATE_OF_STATISTICS as date) = HOSPITAL_ADMISSIONS.DATE_OF_STATISTICS