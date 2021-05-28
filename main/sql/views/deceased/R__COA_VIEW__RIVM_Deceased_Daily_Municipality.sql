-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
CREATE OR ALTER VIEW [VWSDEST].[V_RIVM_DECEASED_DAILY_PER_MUNICIPALITY]
AS

SELECT
    DECEASED_ACTUAL AS COVID_DAILY
,   DECEASED_7D_AVG AS COVID_DAILY_MOVING_AVERAGE
,	DECEASED_CUMULATIVE AS COVID_TOTAL
,	MUNICIPALITY_CODE AS GMCODE
,   DATE_OF_REPORT_UNIX AS DATE_UNIX
,   [dbo].[CONVERT_DATETIME_TO_UNIX](DATE_LAST_INSERTED) AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.RIVM_DECEASED_DAILY_PER_MUNICIPALITY
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.RIVM_DECEASED_DAILY_PER_MUNICIPALITY) 
