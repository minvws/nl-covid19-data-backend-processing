﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.
 
 CREATE   PROCEDURE [dbo].[SP_CBS_POPULATION_AGEGROUP_HOSPITAL_IC]
 AS
 BEGIN
 
 WITH BASE_CTE AS (
 SELECT 
      DATUM_PEILING
     ,LEEFTIJD
     ,CASE 
         WHEN LEEFTIJD >= 0      AND LEEFTIJD <= 9   THEN '0-19'
         WHEN LEEFTIJD >= 10     AND LEEFTIJD <= 19  THEN '0-19'
         WHEN LEEFTIJD >= 20     AND LEEFTIJD <= 29  THEN '20-29'
         WHEN LEEFTIJD >= 30     AND LEEFTIJD <= 39  THEN '30-39'
         WHEN LEEFTIJD >= 40     AND LEEFTIJD <= 49  THEN '40-49'
         WHEN LEEFTIJD >= 50     AND LEEFTIJD <= 59  THEN '50-59'
         WHEN LEEFTIJD >= 60     AND LEEFTIJD <= 69  THEN '60-69'
         WHEN LEEFTIJD >= 70     AND LEEFTIJD <= 79  THEN '70-79'
         WHEN LEEFTIJD >= 80     AND LEEFTIJD <= 89  THEN '80-89'
         WHEN LEEFTIJD >= 90                         THEN '90+'
         END AS AGEGROUP
     ,POPULATIE
     FROM [VWSSTATIC].[CBS_POPULATION_BASE]
     WHERE [DATE_LAST_INSERTED] = ( SELECT MAX([DATE_LAST_INSERTED])  FROM [VWSSTATIC].[CBS_POPULATION_BASE] )
 )
 ,
 TOTALS_CTE AS (
 SELECT 
      DATUM_PEILING
     ,AGEGROUP
     ,SUM(POPULATIE) AS POPULATIE
 FROM BASE_CTE
 GROUP BY [AGEGROUP], [DATUM_PEILING]
 -- ORDER BY DATUM_PEILING, AGEGROUP
 )
     INSERT INTO [VWSSTATIC].[CBS_POPULATION_AGEGROUP_HOSPITAL_IC]
     (
      [DATUM_PEILING]
     ,[AGEGROUP]
     ,[POPULATIE]
     ,POPULATIE_TOTAL
     ,INHABITANTS_PERCENTAGE
     )
 SELECT  
     
      DATUM_PEILING
     ,AGEGROUP
     ,POPULATIE
     ,SUM(POPULATIE) OVER (PARTITION BY DATUM_PEILING)                                       AS POPULATIE_TOTAL
     ,ROUND(CAST(POPULATIE AS FLOAT) / SUM(POPULATIE) OVER (PARTITION BY DATUM_PEILING),3)   AS INHABITANTS_PERCENTAGE
 FROM TOTALS_CTE
 ORDER BY DATUM_PEILING, AGEGROUP
 END;