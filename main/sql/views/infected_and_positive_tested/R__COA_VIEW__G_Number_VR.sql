-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.


CREATE OR ALTER VIEW VWSDEST.V_G_NUMBER_VR AS

SELECT [G_NUMBER] AS g_number
      ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_RANGE_START]) AS date_start_unix
      ,dbo.CONVERT_DATETIME_TO_UNIX([DATE_OF_REPORT]) AS date_end_unix
      ,VRCODE
      ,dbo.CONVERT_DATETIME_TO_UNIX(DATE_LAST_INSERTED) AS date_of_insertion_unix
FROM VWSDEST.G_NUMBER_VR
WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) from VWSDEST.G_NUMBER_VR)
AND G_NUMBER IS NOT NULL -- Only keep dates for which g number can be calculated (requires 14 days of data)