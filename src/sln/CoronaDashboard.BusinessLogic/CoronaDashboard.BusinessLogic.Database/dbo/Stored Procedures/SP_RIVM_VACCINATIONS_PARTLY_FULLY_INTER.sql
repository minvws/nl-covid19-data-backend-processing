﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

CREATE   PROCEDURE [DBO].[SP_RIVM_VACCINATIONS_PARTLY_FULLY_INTER]
AS
BEGIN
    INSERT INTO [VWSINTER].[RIVM_VACCINATIONS_PARTLY_FULLY]
    (
        [RECORDID],
        [REPORTINGCOUNTRY],
        [RECORDTYPE],
        [RECORDTYPEVERSION],
        [SUBJECT],
        [DATASOURCE],
        [STATUS],
        [DATEUSEDFORSTATISTICS],
        [REGION],
        [VACCINE],
        [NUMBERDOSESRECEIVED],
        [TARGETGROUP],
        [DOSEFIRST],
        [DOSESECOND],
        [DOSEUNK],
        [DOSEFIRSTREFUSED],
        [DENOMINATOR],
        [TARGETGROUPCOMMENT],
        [GENERALCOMMENT],
        [DATE_OF_REPORT],
        [DATE_OF_STATISTICS],
        [END_ISO_WEEK],
        [BIRTH_YEAR],
        [CUMSUM_VACCINATION_PARTLY],
        [CUMSUM_VACCINATION_COMPLETED],
        [CUMSUM_VACCINATION_BOOSTER],
        [POPULATION]
    )
    SELECT
        [RECORDID],
        [REPORTINGCOUNTRY],
        [RECORDTYPE],
        [RECORDTYPEVERSION],
        [SUBJECT],
        [DATASOURCE],
        [STATUS],
        [DATEUSEDFORSTATISTICS],
        [REGION],
        [VACCINE],
        CAST(ISNULL(NULLIF([NUMBERDOSESRECEIVED], 'UNK'), 0) AS INT),
        [TARGETGROUP],
        CAST(ISNULL(NULLIF([DOSEFIRST], ''), 0) AS INT),
        CAST(ISNULL(NULLIF([DOSESECOND], ''), 0) AS INT),
        CAST(ISNULL(NULLIF([DOSEUNK], ''), 0) AS INT),
        [DOSEFIRSTREFUSED],
        [DENOMINATOR],
        [TARGETGROUPCOMMENT],
        [GENERALCOMMENT],
        CONVERT(DATETIME, [DATE_OF_REPORT], 105),
        CONVERT(DATETIME, [DATE_OF_STATISTICS], 105),
        CONVERT(DATETIME, [END_ISO_WEEK], 105),
        [BIRTH_YEAR],
        CAST(ISNULL(NULLIF([CUMSUM_VACCINATION_PARTLY], ''), 0) AS INT),
        CAST(ISNULL(NULLIF([CUMSUM_VACCINATION_COMPLETED], ''), 0) AS INT),
        CAST(ISNULL(NULLIF([CUMSUM_VACCINATION_BOOSTER], ''), 0) AS INT),
        [POPULATION]
    FROM 
        [VWSSTAGE].[RIVM_VACCINATIONS_PARTLY_FULLY]
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].[RIVM_VACCINATIONS_PARTLY_FULLY])
END;