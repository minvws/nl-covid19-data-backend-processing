﻿-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE   PROCEDURE [dbo].[SP_SEWER_MEASUREMENTS_PER_MUNICIPALITY_ARCHIVE_DEST]
AS
BEGIN

    WITH SELECTED_TO_BE_ARCHIVED AS (
    SELECT
        [ID],
        [WEEK_UNIX],
        GMCODE,
        AVERAGE,
        NUMBER_OF_MEASUREMENTS,
        NUMBER_OF_LOCATIONS,
        AVERAGE_RNA_FLOW_PER_100000,
        DATE_LAST_INSERTED
    FROM [VWSDEST].[SEWER_MEASUREMENTS_PER_MUNICIPALITY_ARCHIVE]
    WHERE DATE_LAST_INSERTED IN (
        SELECT SubQueryC.DATE_LAST_INSERTED
        FROM(
        SELECT SubQueryB.DATE_LAST_INSERTED, SubQueryB.RANKING
        FROM (
            SELECT SubQueryA.DATE_LAST_INSERTED, rank() OVER(ORDER BY DATE_LAST_INSERTED DESC) RANKING
            FROM (
            SELECT DISTINCT DATE_LAST_INSERTED
            FROM [VWSDEST].[SEWER_MEASUREMENTS_PER_MUNICIPALITY_ARCHIVE]) SubQueryA
        ) SubQueryB
        WHERE SubQueryB.RANKING > 2)SubQueryC))

    INSERT INTO VWSARCHIVE.SEWER_MEASUREMENTS_PER_MUNICIPALITY
        (
        [ID],
        [WEEK_UNIX],
        GMCODE,
        AVERAGE,
        NUMBER_OF_MEASUREMENTS,
        NUMBER_OF_LOCATIONS,
        AVERAGE_RNA_FLOW_PER_100000,
        DATE_LAST_INSERTED
        )
     SELECT
        [ID],
        [WEEK_UNIX],
        GMCODE,
        AVERAGE,
        NUMBER_OF_MEASUREMENTS,
        NUMBER_OF_LOCATIONS,
        AVERAGE_RNA_FLOW_PER_100000,
        DATE_LAST_INSERTED
    FROM SELECTED_TO_BE_ARCHIVED;

    DELETE FROM VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY_ARCHIVE
    WHERE DATE_LAST_INSERTED IN (
        SELECT SubQueryC.DATE_LAST_INSERTED
        FROM(
        SELECT SubQueryB.DATE_LAST_INSERTED, SubQueryB.RANKING
        FROM (
            SELECT SubQueryA.DATE_LAST_INSERTED, rank() OVER(ORDER BY DATE_LAST_INSERTED DESC) RANKING
            FROM (
            SELECT DISTINCT DATE_LAST_INSERTED
            FROM VWSDEST.SEWER_MEASUREMENTS_PER_MUNICIPALITY_ARCHIVE) SubQueryA
        ) SubQueryB
        WHERE SubQueryB.RANKING > 2)SubQueryC);
END;