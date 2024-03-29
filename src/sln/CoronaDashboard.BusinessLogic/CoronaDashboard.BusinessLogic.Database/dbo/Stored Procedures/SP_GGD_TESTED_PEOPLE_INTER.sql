﻿CREATE    PROCEDURE [dbo].[SP_GGD_TESTED_PEOPLE_INTER]
 AS
 BEGIN
 
 -- Zet de Date_Last_Inserted in een variabele
 DECLARE @DateTimeNow AS DateTime = GETDATE()
 
 INSERT INTO VWSINTER.GGD_TESTED_PEOPLE
     (
        [VERSION],
        DATE_OF_REPORT,
        DATE_OF_STATISTICS,
        SECURITY_REGION_CODE,
        SECURITY_REGION_NAME,
        TESTED_WITH_RESULT,
        TESTED_POSITIVE,
        Date_Last_Inserted
     )
     SELECT
         [VERSION],
         DATE_OF_REPORT,
         DATE_OF_STATISTICS,
         SECURITY_REGION_CODE,
         SECURITY_REGION_NAME,
         TESTED_WITH_RESULT,
         TESTED_POSITIVE,
         @DateTimeNow as Date_Last_Inserted
     FROM
        VWSSTAGE.GGD_TESTED_PEOPLE
     WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.GGD_TESTED_PEOPLE)
 
 INSERT INTO VWSINTER.GGD_TESTED_PEOPLE
     (
        [VERSION],
        DATE_OF_REPORT,
        DATE_OF_STATISTICS,
        SECURITY_REGION_CODE,
        SECURITY_REGION_NAME,
        TESTED_WITH_RESULT,
        TESTED_POSITIVE,
        Date_Last_Inserted
     )
     SELECT
         [VERSION],
         DATE_OF_REPORT,
         DATE_OF_STATISTICS,
         SECURITY_REGION_CODE,
         SECURITY_REGION_NAME,
         TESTED_WITH_RESULT,
         TESTED_POSITIVE,
         @DateTimeNow as Date_Last_Inserted
     FROM
        VWSSTATIC.GGD_TESTED_PEOPLE
     WHERE DATE_LAST_INSERTED  = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTATIC.GGD_TESTED_PEOPLE)
 
 END;