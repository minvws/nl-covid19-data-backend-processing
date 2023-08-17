-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   VIEW VWSREPORT.V_PBI_HOSPITAL_NICE_BY_AGE_GROUP AS   
    SELECT    
        DATE_OF_STATISTICS_WEEK_START                   AS [Week start]
        ,DATE_OF_STATISTICS_WEEK_END                    AS [Week einde]
        ,CAST([DATE_LAST_INSERTED] as date)             AS [Update datum]
        ,AGE_GROUP_GROUPED                              AS [Leeftijdsgroep]

        ,IC_ADMISSION                                   AS [IC Opnames]
        ,IC_ADMISSION_NOTIFICATION                      AS [IC Opnames Gemeld]        
        ,IC_ADMISSION_PER1M                             AS [IC Opnames (per 1M)]

        ,HOSPITAL_ADMISSION                             AS [Ziekenhuisopnames]
        ,HOSPITAL_ADMISSION_NOTIFICATION                AS [Ziekenhuisopnames Gemeld]
        ,HOSPITAL_ADMISSION_PER1M                       AS [Ziekenhuisopnames (per 1M)]
   
    FROM 
        [VWSDEST].[RIVM_HOSPITAL_IC_ADMISSIONS_OVERTIME_BYAGEGROUP]
    
    WHERE
        DATE_LAST_INSERTED=(
            SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[RIVM_HOSPITAL_IC_ADMISSIONS_OVERTIME_BYAGEGROUP]
            )