-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.


CREATE   PROCEDURE dbo.SP_REINDEXING AS
    exec sp_updatestats;
--    HotFix 05-10-20: The emptying of the cache can't be done at the
--    moment by service acc. Therefore for now commented out.
--    dbcc freeproccache;