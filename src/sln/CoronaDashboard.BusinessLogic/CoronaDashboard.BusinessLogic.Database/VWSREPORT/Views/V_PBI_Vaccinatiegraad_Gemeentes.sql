-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   VIEW VWSREPORT.V_PBI_Vaccinatiegraad_Gemeentes AS
SELECT
    DATE_OF_REPORT                                                                                                                                                                                          AS [Update Datum],
    DATE_OF_STATISTICS                                                                                                                                                                                      AS [Datum],
    [REGION_CODE]                                                                                                                                                                                           AS [GMCode],
    AGE_GROUP                                                                                                                                                                                               AS [Leeftijds categorie],
    [BIRTH_YEAR]                                                                                                                                                                                            AS [Geboortejaar],
    CASE WHEN ISNUMERIC(VACCINATION_COVERAGE_ALL) =1 THEN CAST(CAST(ROUND(VACCINATION_COVERAGE_ALL, 0) AS INT) AS varchar(10)) + '%' ELSE  VACCINATION_COVERAGE_ALL_LABEL + '%' END                         AS [Vaccinatiegraad 1 prik],
    VACCINATION_COVERAGE_ALL_LABEL                                                                                                                                                                          AS [Vaccinatiegraad 1 prik label],
    CASE WHEN ISNUMERIC(VACCINATION_COVERAGE_COMPLETED) =1 THEN CAST(CAST(ROUND(VACCINATION_COVERAGE_COMPLETED, 0) AS INT) AS varchar(10)) + '%' ELSE  VACCINATION_COVERAGE_COMPLETED_LABEL  + '%' END      AS [Vaccinatiegraad volledig],
    VACCINATION_COVERAGE_COMPLETED_LABEL                                                                                                                                                                    AS [Vaccinatiegraad volledig label]
FROM VWSDEST.CIMS_VACCINATED_PER_AGE_GROUP_GM_VR
WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM VWSDEST.CIMS_VACCINATED_PER_AGE_GROUP_GM_VR)
    AND LEFT(REGION_CODE,2) = 'GM'