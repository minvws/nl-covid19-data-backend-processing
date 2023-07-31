-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   VIEW VWSREPORT.V_PBI_CBS_Inwoners_NL
AS
    SELECT
        DATUM_PEILING       AS Peildatum
        ,POPULATIE           AS Populatie
        ,DATE_LAST_INSERTED  AS [Update datum]
    FROM [VWSSTATIC].[CBS_POPULATION_NL]
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.CBS_POPULATION_NL)