-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.


CREATE   PROCEDURE [dbo].[SP_DEST_ECDC_VACCINE_COVERAGE_TOTAL]
AS
BEGIN

    INSERT INTO VWSDEST.ECDC_VACCINE_COVERAGE_TOTAL (
         [DATE_OF_REPORT]                    
        ,[DATE_OF_STATISTICS]                
        ,[BIRTH_YEAR]                            
        ,[VACCINATION_COVERAGE_ALL]           
        ,[VACCINATION_COVERAGE_COMPLETED]    
    )
    SELECT
    CONVERT(DATETIME, DATE_OF_REPORT, 105)                      AS [DATE_OF_REPORT]
    ,CONVERT(DATETIME, DATE_OF_STATISTICS, 105)                  AS [DATE_OF_STATISTICS]
    ,CASE 
        WHEN BIRTH_YEAR = '<2004'     THEN '-2003'
        WHEN BIRTH_YEAR = '<=2003'    THEN '-2003'
        WHEN BIRTH_YEAR = '<=2009'    THEN '-2009'
        END AS [BIRTH_YEAR]                        
    ,CAST(REPLACE([VACCINATION_COVERAGE_PARTLY], ',', '.')  AS DECIMAL(19,3))    AS [VACCINATION_COVERAGE_ALL]
    ,CAST(REPLACE([VACCINATION_COVERAGE_COMPLETED], ',', '.')  AS DECIMAL(19,3))    AS VACCINATION_COVERAGE_COMPLETED      
FROM VWSSTAGE.ECDC_VACCINE_COVERAGE_TOTAL
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.ECDC_VACCINE_COVERAGE_TOTAL)

END;