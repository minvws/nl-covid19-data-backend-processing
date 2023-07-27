-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE [dbo].[SP_RIVM_VACCINE_STOCK_INTER]
AS
BEGIN

    CREATE TABLE #DataCheck (
        VACCINE_NAME nvarchar(255), 
        TOTAL_STOCK int, 
        FREE_STOCK int)

    BEGIN TRANSACTION
        INSERT INTO 
            VWSINTER.RIVM_VACCINE_STOCK (
                DATE_OF_REPORT,
                DATE_OF_STATISTICS,
                [VACCINE_NAME],
                TOTAL_STOCK,
                FREE_STOCK
        )
        OUTPUT INSERTED.VACCINE_NAME, INSERTED.TOTAL_STOCK, INSERTED.FREE_STOCK
        INTO #DataCheck (VACCINE_NAME, TOTAL_STOCK, FREE_STOCK)
        SELECT
            CAST([DATE_OF_REPORT] AS DATETIME) AS [DATE_OF_REPORT],
            CAST([DATE_OF_STATISTICS] AS DATETIME) AS [DATE_OF_STATISTICS],
            CASE 
                WHEN [VACCINE_NAME] = 'Pfizer bv' THEN 'BioNTech/Pfizer'
                WHEN [VACCINE_NAME] = 'Moderna Switzerland GmbH' THEN 'Moderna' 
                WHEN [VACCINE_NAME] = 'AstraZeneca AB' THEN 'AstraZeneca' 
                WHEN [VACCINE_NAME] = 'Janssen Pharmaceutica NV' THEN 'Janssen' 
                ELSE [VACCINE_NAME] END [VACCINE_NAME] ,      
            CAST([TOTAL_STOCK] AS INT) AS [TOTAL_STOCK],
            CAST([FREE_STOCK] AS INT) AS [FREE_STOCK]
        FROM 
            VWSSTAGE.RIVM_VACCINE_STOCK
        WHERE 
            DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.RIVM_VACCINE_STOCK)

        IF (0 < (SELECT COUNT(*) FROM #DataCheck WHERE FREE_STOCK > TOTAL_STOCK ))
        BEGIN
            THROW 50005, N'FREE_STOCK is larger than TOTAL_STOCK IN VACCINE_SUPPLY workflows, stopping...', 1; 
        END
    COMMIT;
    
END