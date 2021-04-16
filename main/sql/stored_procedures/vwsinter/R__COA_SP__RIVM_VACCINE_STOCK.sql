-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE [dbo].[SP_RIVM_VACCINE_STOCK_INTER]
AS
BEGIN
    INSERT INTO 
        VWSINTER.RIVM_VACCINE_STOCK (
            DATE_OF_REPORT,
            DATE_OF_STATISTICS,
            [VACCINE_NAME],
            TOTAL_STOCK,
            FREE_STOCK
    )
    SELECT
        CONVERT(DATETIME,DATE_OF_REPORT, 105) AS DATE_OF_REPORT,
        CONVERT(DATETIME,DATE_OF_STATISTICS, 105) AS DATE_OF_STATISTICS,
        CASE WHEN [VACCINE_NAME] = 'Pfizer Inc.' THEN 'BioNTech/Pfizer' ELSE [VACCINE_NAME] END [VACCINE_NAME] ,      
        CAST([TOTAL_STOCK] AS INT) AS [TOTAL_STOCK],
        CAST([FREE_STOCK] AS INT) AS [FREE_STOCK]
    FROM 
        VWSSTAGE.RIVM_VACCINE_STOCK
    WHERE 
        DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.RIVM_VACCINE_STOCK)
END;