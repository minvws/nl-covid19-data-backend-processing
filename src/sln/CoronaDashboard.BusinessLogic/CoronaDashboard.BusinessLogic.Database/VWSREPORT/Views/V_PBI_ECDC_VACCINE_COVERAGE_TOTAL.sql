-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   VIEW VWSREPORT.V_PBI_ECDC_VACCINE_COVERAGE_TOTAL AS
SELECT AGE_12_PLUS.DATE_OF_STATISTICS                                           AS Datum
    ,AGE_12_PLUS.[BIRTH_YEAR]                                                   AS Geboortejaar_12_plus
    ,CAST(ROUND(AGE_12_PLUS.VACCINATION_COVERAGE_ALL, 1) AS DECIMAL(9,1))       AS Vaccinatiegraad_12_plus_1_prik
    ,CAST(ROUND(AGE_12_PLUS.VACCINATION_COVERAGE_COMPLETED, 1) AS DECIMAL(9,1)) AS Vaccinatiegraad_12_plus_volledig
    ,AGE_18_PLUS.[BIRTH_YEAR]                                                   AS Geboortejaar_18_plus
    ,CAST(ROUND(AGE_18_PLUS.VACCINATION_COVERAGE_ALL, 1) AS DECIMAL(9,1))       AS Vaccinatiegraad_18_plus_1_prik
    ,CAST(ROUND(AGE_18_PLUS.VACCINATION_COVERAGE_COMPLETED, 1) AS DECIMAL(9,1)) AS Vaccinatiegraad_18_plus_volledig
    ,AGE_12_PLUS.DATE_LAST_INSERTED                                             AS [Update datum]
FROM (
    SELECT *
    FROM VWSDEST.ECDC_VACCINE_COVERAGE_TOTAL
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM VWSDEST.ECDC_VACCINE_COVERAGE_TOTAL)
    AND BIRTH_YEAR = '-2009'
    ) AGE_12_PLUS
FULL JOIN (
    SELECT *
    FROM VWSDEST.ECDC_VACCINE_COVERAGE_TOTAL
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM VWSDEST.ECDC_VACCINE_COVERAGE_TOTAL)
    AND BIRTH_YEAR = '-2003'
) AGE_18_PLUS
ON AGE_12_PLUS.DATE_OF_REPORT = AGE_18_PLUS.DATE_OF_REPORT