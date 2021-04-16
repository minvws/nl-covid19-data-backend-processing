-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

-- Move download data from staging to intermediate table.
CREATE OR ALTER PROCEDURE DBO.SP_CORONAMELDER_DOWNLOADS_INTER
AS
BEGIN
    INSERT INTO VWSINTER.CORONAMELDER_DOWNLOADS
        ([Date (yyyy-mm-dd)],
        [Downloads App Store (iOS) (daily)],
        [Downloads Play Store (Android) (daily)],
        [Downloads Huawei App Gallery (Android) (daily)],
        [Total downloads (daily)],
        [Total downloads (cumulative)])
    SELECT 
        [Date (yyyy-mm-dd)],
        [Downloads App Store (iOS) (daily)],
        [Downloads Play Store (Android) (daily)],
        [Downloads Huawei App Gallery (Android) (daily)],
        [Total downloads (daily)],
        [Total downloads (cumulative)]
    FROM 
       VWSSTAGE.CORONAMELDER_DOWNLOADS
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSSTAGE.CORONAMELDER_DOWNLOADS)
END;
GO