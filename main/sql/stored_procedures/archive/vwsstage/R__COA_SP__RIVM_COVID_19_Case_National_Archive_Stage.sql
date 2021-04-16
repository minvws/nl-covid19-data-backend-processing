-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE dbo.SP_RIVM_COVID_19_CASE_NATIONAL_ARCHIVE_STAGE
AS
BEGIN

BEGIN TRANSACTION;

    DECLARE @TmpTable TABLE (
        [DATE_FILE] [varchar] (100) NULL,
        [DATE_STATISTICS] [varchar] (100) NULL,
        [DATE_STATISTICS_TYPE] [varchar](100) NULL,
        [AGEGROUP] [varchar] (100) NULL,
        [SEX] [varchar] (100) NULL,
        [PROVINCE] [varchar] (100) NULL,
        [HOSPITAL_ADMISSION] [varchar] (100) NULL,
        [DECEASED] [varchar] (100) NULL,
        [WEEK_OF_DEATH] [varchar] (100) NULL,
        [MUNICIPAL_HEALTH_SERVICE] [varchar] (100) NULL,
        [DATE_LAST_INSERTED] [datetime] NULL
    );

    
	DELETE FROM VWSSTAGE.RIVM_COVID_19_CASE_NATIONAL
		OUTPUT DELETED.DATE_FILE
                ,DELETED.DATE_STATISTICS
                ,DELETED.DATE_STATISTICS_TYPE
                ,DELETED.AGEGROUP
                ,DELETED.SEX
                ,DELETED.PROVINCE
                ,DELETED.HOSPITAL_ADMISSION
                ,DELETED.DECEASED
                ,DELETED.WEEK_OF_DEATH
                ,DELETED.MUNICIPAL_HEALTH_SERVICE
                ,DELETED.DATE_LAST_INSERTED
        INTO  @TmpTable
	WHERE DATE_LAST_INSERTED IN (
        SELECT SubQueryC.DATE_LAST_INSERTED
        FROM(
        SELECT SubQueryB.DATE_LAST_INSERTED, SubQueryB.RANKING 
        FROM (
            SELECT SubQueryA.DATE_LAST_INSERTED, rank() OVER(ORDER BY DATE_LAST_INSERTED DESC) RANKING
            FROM (
            SELECT DISTINCT DATE_LAST_INSERTED
            FROM VWSSTAGE.RIVM_COVID_19_CASE_NATIONAL) SubQueryA
        ) SubQueryB
        WHERE SubQueryB.RANKING > 2)SubQueryC);


    INSERT INTO VWSARCHIVE.RIVM_COVID_19_CASE_NATIONAL_ARCHIVE_STAGE
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
    FROM @TmpTable;
COMMIT;
END;