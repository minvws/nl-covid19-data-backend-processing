-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 -- 1) CREATE STORE PROCEDURE(S) INTER -> REPORT.....
 CREATE   PROCEDURE [dbo].[SP_ECDC_VACCINATION_COVERAGES_INTER_TO_REPORT]
 AS
 BEGIN
     WITH BASE_CTE AS
     (
         SELECT 
             [YEAR_WEEK_ISO],
             [REPORTING_COUNTRY],
             [DENOMINATOR],
             [NUMBER_DOSES_RECEIVED],
             [NUMBER_DOSES_EXPORTED],
             [FIRST_DOSE],
             [FIRST_DOSE_REFUSED],
             [SECOND_DOSE],
             [DOSE_ADDITIONAL1],
             [UNKNOWN_DOSE],
             [REGION],
             [TARGET_GROUP],
             [VACCINE],
             [POPULATION]
         FROM [VWSINTER].[ECDC_VACCINATION_COVERAGES]
         WHERE UPPER([TARGET_GROUP]) IN ('ALL') 
             AND [REGION] = [REPORTING_COUNTRY]
             AND [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[ECDC_VACCINATION_COVERAGES])
     ),
     TOTAL_CTE AS (
         SELECT 
             [REPORTING_COUNTRY],
             [DENOMINATOR],
             SUM([FIRST_DOSE]) AS [SUM_FIRST_DOSE]
         FROM [BASE_CTE]
         GROUP BY [REPORTING_COUNTRY], [DENOMINATOR]
     )
     INSERT INTO [VWSREPORT].[ECDC_VACCINATION_COVERAGES] (
         [REPORTING_COUNTRY],
         [UPTAKE_ONE_VACCINE_DOSE]
     )
     SELECT 
         [REPORTING_COUNTRY],
         CAST((CAST([SUM_FIRST_DOSE] AS DECIMAL) / [DENOMINATOR]) * 100 AS decimal(18,1)) AS [UPTAKE_ONE_VACCINE_DOSE]
     FROM TOTAL_CTE
 
    --  TRUNCATE TABLE [VWSINTER].[ECDC_VACCINATION_COVERAGES];
 END