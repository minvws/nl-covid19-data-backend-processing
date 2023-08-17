-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE [dbo].[SP_CALENDAR]
AS
BEGIN
    TRUNCATE TABLE VWSSTATIC.CALENDAR
    
    
    DECLARE @MinDate DATE = '20190101',
            @MaxDate DATE = '20300101';

INSERT INTO VWSSTATIC.CALENDAR
    (
        [DAY]
    )
    SELECT  TOP (DATEDIFF(DAY, @MinDate, @MaxDate) + 1)
            Date = DATEADD(DAY, ROW_NUMBER() OVER(ORDER BY a.object_id) - 1, @MinDate)
    FROM    sys.all_objects a
            CROSS JOIN sys.all_objects b;

END