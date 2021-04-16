-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Create view for pulling intensive care admissions
CREATE OR ALTER VIEW [VWSDEST].[V_RIVM_INTENSIVE_CARE_ADMISSIONS] AS
SELECT
    [DATE_OF_STATISTICS_UNIX] AS DATE_UNIX
,   IC_admission AS ADMISSIONS_ON_DATE_OF_ADMISSION
,   IC_admission_notification AS ADMISSIONS_ON_DATE_OF_REPORTING
,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED)  AS DATE_OF_INSERTION_UNIX
FROM VWSDEST.RIVM_IC_OPNAME
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSDEST.RIVM_IC_OPNAME);

GO