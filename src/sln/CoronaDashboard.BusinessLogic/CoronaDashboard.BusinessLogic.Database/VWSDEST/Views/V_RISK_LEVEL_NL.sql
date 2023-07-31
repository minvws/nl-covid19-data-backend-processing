-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE    VIEW [VWSDEST].[V_RISK_LEVEL_NL] AS
WITH BASE_CTE AS
(
    --retrieve only valid records
    SELECT 
     [RISK_LEVEL]              
    ,[HOSP_WEEK_START]
    ,[HOSP_WEEK_END]  
    ,[HOSP_7D_AVG]    
    ,[IC_WEEK_START]  
    ,[IC_WEEK_END]    
    ,[IC_7D_AVG]       
    ,[VALID_FROM]                   
    ,[DATE_LAST_INSERTED]               
    FROM [VWSDEST].[RISK_LEVEL_NL_HISTORY]
    WHERE VALID = 1
)
select                           
       [risk_level]
      ,dbo.[convert_datetime_to_unix]([hosp_week_start])                    as hospital_admissions_on_date_of_admission_moving_average_rounded_date_start_unix
      ,dbo.[convert_datetime_to_unix]([hosp_week_end]  )                    as hospital_admissions_on_date_of_admission_moving_average_rounded_date_end_unix
      ,CAST(ROUND(HOSP_7D_AVG,0) AS INTEGER)                                as hospital_admissions_on_date_of_admission_moving_average_rounded
      ,dbo.[convert_datetime_to_unix]([ic_week_start])                      as intensive_care_admissions_on_date_of_admission_moving_average_rounded_date_start_unix
      ,dbo.[convert_datetime_to_unix]([ic_week_end]  )                      as intensive_care_admissions_on_date_of_admission_moving_average_rounded_date_end_unix
      ,CAST(ROUND(IC_7D_AVG,0) AS INTEGER)                                  as intensive_care_admissions_on_date_of_admission_moving_average_rounded
      ,dbo.convert_datetime_to_unix([valid_from])                           as valid_from_unix
      ,dbo.[convert_datetime_to_unix](cast([date_last_inserted] as date))   as date_unix
      ,dbo.[convert_datetime_to_unix]([date_last_inserted])                 as date_of_insertion_unix
  FROM BASE_CTE
  WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM BASE_CTE)