﻿CREATE   VIEW VWSDEST.V_NURSING_HOMES_TOTALS_BACK_UP
AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY DATE_OF_REPORT ASC) AS ID,
    DATE_OF_REPORT,
	DATE_OF_REPORT_UNIX,
	INFECTED_NURSERY_DAILY,
	DECEASED_NURSERY_DAILY,
	TOTAL_NEW_REPORTED_LOCATIONS,
	TOTAL_REPORTED_LOCATIONS,
	DATE_LAST_INSERTED
FROM VWSDEST.NURSING_HOMES_TOTALS
WHERE DATE_LAST_INSERTED = (SELECT max(DATE_LAST_INSERTED) FROM VWSDEST.NURSING_HOMES_TOTALS)