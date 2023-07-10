-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE   VIEW [VWSDEST].[V_CORONAMELDER_WARNING]
AS
    SELECT
        [WARNED_DAILY]                                      AS [count]
        ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_REPORT])     AS date_unix
        ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_LAST_INSERTED]) AS date_of_insertion_unix
    FROM 
        VWSDEST.CORONAMELDER
    WHERE 
        WARNED_DAILY IS NOT NULL AND 
        DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) FROM VWSDEST.CORONAMELDER) AND
        DATE_OF_REPORT >= CAST('2020-10-10' as date) -- "In Use" start date of Corona app (datum waarop Corona App in werking is gesteld)