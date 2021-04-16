-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE DBO.SP_POSITIVE_TESTED_PEOPLE
AS
BEGIN
-- Move positively tested persons data from intermediate table to destination table. 

-- Normalization variable that is used in the select and insert into statement. 
    DECLARE @NORMALIZATION FLOAT;
    SET @NORMALIZATION = 17408573.0/100000.0;

-- Main select and insert statement for people tested positively. Calculation per date of report.  
    INSERT INTO VWSDEST.POSITIVE_TESTED_PEOPLE
    (DATE_OF_REPORT, DATE_OF_REPORT_UNIX, INFECTED_DAILY_TOTAL, INFECTED_DAILY_INCREASE)
    SELECT
        DATE_OF_PUBLICATION AS DATE_OF_REPORT
    ,   dbo.CONVERT_DATETIME_TO_UNIX(DATE_OF_PUBLICATION) AS [DATE_OF_REPORT_UNIX]
    ,   SUM(CAST(Total_reported AS FLOAT)) AS [INCREASE_ABSOLUTE]
    ,   SUM(CAST(Total_reported AS FLOAT))/(@NORMALIZATION) AS [INCREASE]
    FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY
        WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSINTER.RIVM_COVID_19_NUMBER_MUNICIPALITY)
        GROUP BY DATE_OF_PUBLICATION
END;