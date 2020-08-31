-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE PROCEDURE dbo.SP_RIVM_COVID_19_CASE_NATIONAL_BACK_UP
AS
BEGIN
    DELETE VWSSTATIC.RIVM_COVID_19_CASE_NATIONAL_BACK_UP 
    INSERT INTO VWSSTATIC.RIVM_COVID_19_CASE_NATIONAL_BACK_UP
        (DATE_FILE, 
        DATE_STATISTICS, 
        DATE_STATISTICS_TYPE, 
        AGEGROUP, 
        SEX, 
        PROVINCE, 
        HOSPITAL_ADMISSION, 
        DECEASED, 
        WEEK_OF_DEATH, 
        MUNICIPAL_HEALTH_SERVICE, 
        DATE_LAST_INSERTED)
    SELECT 
        DATE_FILE, 
        DATE_STATISTICS, 
        DATE_STATISTICS_TYPE, 
        AGEGROUP, 
        SEX, 
        PROVINCE, 
        HOSPITAL_ADMISSION, 
        DECEASED, 
        WEEK_OF_DEATH, 
        MUNICIPAL_HEALTH_SERVICE, 
        DATE_LAST_INSERTED
    FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL
    WHERE DATE_LAST_INSERTED IN (   
                    SELECT DATE_LAST_INSERTED
                    FROM (
                    SELECT DATE_LAST_INSERTED, rank() OVER(ORDER BY DATE_LAST_INSERTED DESC) RANKING
                    FROM (        
                    SELECT distinct a.DATE_LAST_INSERTED 
                    from (SELECT DATE_LAST_INSERTED, 
                                 RANK() OVER (PARTITION BY DATE_FILE ORDER BY DATE_LAST_INSERTED DESC) RANKING
                    FROM VWSINTER.RIVM_COVID_19_CASE_NATIONAL) a
                    WHERE a.RANKING = 1)b)c
                    WHERE c.RANKING = 1);
END;