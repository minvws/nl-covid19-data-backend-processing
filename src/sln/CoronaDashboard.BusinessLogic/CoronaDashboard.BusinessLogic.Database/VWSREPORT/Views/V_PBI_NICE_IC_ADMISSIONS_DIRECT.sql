-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
CREATE   VIEW VWSREPORT.V_PBI_NICE_IC_ADMISSIONS_DIRECT AS

    SELECT
        [DATE]                  AS [Datum],
        [VALUE]                 AS [IC opnames],
        [DATE_LAST_INSERTED]    AS [Update datum]
    FROM 
       VWSINTER.NICE_IC_ADMISSIONS
  -- Include records that are loaded into the database up to 8 days before last insert
    WHERE DATE_LAST_INSERTED >=
        DATEADD(day, -8, (SELECT MAX(DATE_LAST_INSERTED) FROM [VWSINTER].[NICE_IC_ADMISSIONS]))