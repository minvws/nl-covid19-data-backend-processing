-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   VIEW VWSREPORT.V_PBI_Besmettelijk AS
    SELECT
        CAST([DATE] as date)                            AS [Datum]
    ,   PREV_LOW                                        AS [Besmettelijk ondergrens]
    ,   PREV_AVG                                        AS [Besmettelijk]
    ,   PREV_UP                                         AS [Besmettelijk bovengrens]
    ,CAST([DATE_LAST_INSERTED] as date)                 AS [Update datum]
    FROM 
        VWSINTER.RIVM_INFECTIOUS_PEOPLE
    WHERE 
        DATE_LAST_INSERTED=
            (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.RIVM_INFECTIOUS_PEOPLE)