-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 -- Move reproduction data from staging to intermediate table.
 CREATE    PROCEDURE [dbo].[SP_RIVM_REPRODUCTION_NUMBER_INTER]
 AS
 BEGIN
 
 -- Zet de Date_Last_Inserted in een variabele
 DECLARE @DateTimeNow AS DateTime = GETDATE()
 
 INSERT INTO VWSINTER.RIVM_REPRODUCTION_NUMBER
         ([DATE],
         RT_LOW,
         RT_AVG,
         RT_UP,
         DATE_LAST_INSERTED )
 SELECT 
         [DATE],
         (CASE WHEN RT_LOW = '' THEN NULL ELSE RT_LOW END) AS RT_LOW,
         (CASE WHEN RT_AVG = '' THEN NULL ELSE RT_AVG END) AS RT_AVG,
         (CASE WHEN RT_UP = '' THEN NULL ELSE RT_UP END) AS RT_UP,
         @DateTimeNow as Date_Last_Inserted
     FROM 
        VWSSTAGE.RIVM_REPRODUCTION_NUMBER
     WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.RIVM_REPRODUCTION_NUMBER)
 
 
 INSERT INTO VWSINTER.RIVM_REPRODUCTION_NUMBER
         ([DATE],
         RT_LOW,
         RT_AVG,
         RT_UP,
         DATE_LAST_INSERTED )
 SELECT 
         [DATE],
         (CASE WHEN RT_LOW = '' THEN NULL ELSE RT_LOW END) AS RT_LOW,
         (CASE WHEN RT_AVG = '' THEN NULL ELSE RT_AVG END) AS RT_AVG,
         (CASE WHEN RT_UP = '' THEN NULL ELSE RT_UP END) AS RT_UP,
         @DateTimeNow as Date_Last_Inserted
     FROM 
        VWSSTATIC.RIVM_REPRODUCTION_NUMBER
     WHERE CAST(DATE_LAST_INSERTED as DATE) = (SELECT MAX(CAST(DATE_LAST_INSERTED as DATE)) FROM VWSSTATIC.RIVM_REPRODUCTION_NUMBER)
 
 END;