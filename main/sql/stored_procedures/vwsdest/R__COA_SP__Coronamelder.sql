-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move coronamelder downloads & positives reported data from intermediate to production table.
CREATE OR ALTER PROCEDURE [dbo].[SP_CORONAMELDER]
AS
BEGIN
    INSERT INTO VWSDEST.CORONAMELDER
    (
       [DOWNLOADED_TOTAL]
      ,[WARNED_DAILY] 
      ,[DATE_OF_REPORT]
	  )
    SELECT 
        [Total downloads (cumulative)] AS [DOWNLOADED_TOTAL],
        ISNULL([Reported positive tests through app authorised by GGD (daily)],0) AS  [WARNED_DAILY],
		T1.[Date (yyyy-mm-dd)] AS [DATE_OF_REPORT]
    FROM VWSINTER.CORONAMELDER_DOWNLOADS T1
	LEFT JOIN (SELECT * FROM VWSINTER.CORONAMELDER_POSITIVES
				WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSINTER.CORONAMELDER_POSITIVES)) T2
		ON T1.[Date (yyyy-mm-dd)] = T2.[Date (yyyy-mm-dd)]
    WHERE T1.DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSINTER.CORONAMELDER_DOWNLOADS)
END;
