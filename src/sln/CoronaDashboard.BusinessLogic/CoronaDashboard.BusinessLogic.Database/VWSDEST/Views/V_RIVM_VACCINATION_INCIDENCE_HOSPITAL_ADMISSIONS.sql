-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   VIEW  [VWSDEST].[V_RIVM_VACCINATION_INCIDENCE_HOSPITAL_ADMISSIONS]
AS
SELECT dbo.CONVERT_DATETIME_TO_UNIX([DATE_START])                   AS [date_start_unix]
       , dbo.CONVERT_DATETIME_TO_UNIX([DATE_END])                   AS [date_end_unix]
       ,[AGE_GROUP_RANGE]                                           AS [age_group_range]
       ,[FULLY_VACCINATED_PER_100K]                                 AS [fully_vaccinated_per_100k]
       ,[HAS_ONE_SHOT_OR_NOT_VACCINATED_PER_100K]                   AS [has_one_shot_or_not_vaccinated_per_100k]
       ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED])          AS [date_of_insertion_unix]
FROM [VWSDEST].[RIVM_VACCINATION_INCIDENCE_HOSPITAL]
WHERE [DATE_LAST_INSERTED] =  (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSDEST].[RIVM_VACCINATION_INCIDENCE_HOSPITAL])