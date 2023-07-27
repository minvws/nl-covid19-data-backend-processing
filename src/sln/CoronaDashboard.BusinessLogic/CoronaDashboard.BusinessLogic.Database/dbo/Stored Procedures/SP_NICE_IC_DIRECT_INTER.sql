-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.
CREATE   PROCEDURE DBO.SP_NICE_IC_DIRECT_INTER
AS
BEGIN

INSERT INTO VWSINTER.NICE_IC_ADMISSIONS(
    DATE
    ,VALUE
)
    SELECT
	CAST([DATE] AS DATE) AS DATE
,	CAST([VALUE] AS INT) AS NUMBER_IC_ADMISSIONS
    FROM VWSSTAGE.NICE_IC_ADMISSIONS
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.NICE_IC_ADMISSIONS)
END;