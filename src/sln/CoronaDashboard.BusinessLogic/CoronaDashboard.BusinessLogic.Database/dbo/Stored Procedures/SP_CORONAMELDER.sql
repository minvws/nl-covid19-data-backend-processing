-- Copyright (c) 2021 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move coronamelder downloads & positives reported data from intermediate to production table.
CREATE   PROCEDURE [dbo].[SP_CORONAMELDER]
AS
BEGIN
    INSERT INTO VWSDEST.CORONAMELDER
    (
       [DOWNLOADED_TOTAL]
      ,[WARNED_DAILY] 
      ,[DATE_OF_REPORT]
	  )
    SELECT 
        [DOWNLOADED_TOTAL],
        [WARNED_DAILY],
		COALESCE(DOWNLOADS.[Date (yyyy-mm-dd)],POSITIVES.[Date (yyyy-mm-dd)])  AS [DATE_OF_REPORT]
    FROM 
        (
            SELECT 
                [Date (yyyy-mm-dd)], 
                ISNULL([Total downloads (cumulative)],0) AS [DOWNLOADED_TOTAL]
            FROM  VWSINTER.CORONAMELDER_DOWNLOADS
            WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSINTER.CORONAMELDER_DOWNLOADS)
        ) AS DOWNLOADS
	FULL OUTER JOIN 
        (
            SELECT 
                [Date (yyyy-mm-dd)],
                ISNULL([Reported positive tests through app authorised by GGD (daily)],0) AS  [WARNED_DAILY]
            FROM VWSINTER.CORONAMELDER_POSITIVES
            WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSINTER.CORONAMELDER_POSITIVES)
        ) POSITIVES
		ON DOWNLOADS.[Date (yyyy-mm-dd)] = POSITIVES.[Date (yyyy-mm-dd)]
END;