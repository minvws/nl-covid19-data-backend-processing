-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE OR ALTER PROCEDURE [dbo].[SP_RIVM_IC_OPNAME_INTER]
AS
BEGIN
    INSERT INTO VWSINTER.RIVM_IC_OPNAME(
    [VERSION],
	DATE_OF_REPORT,
    DATE_OF_STATISTICS,
    IC_ADMISSION_NOTIFICATION,
    IC_ADMISSION 
    )
    SELECT
    [VERSION],
	DATE_OF_REPORT,
    DATE_OF_STATISTICS,
    IC_ADMISSION_NOTIFICATION,
    IC_ADMISSION 
	FROM 
        VWSSTAGE.RIVM_IC_OPNAME
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) 
                                  FROM VWSSTAGE.RIVM_IC_OPNAME)
END;
