-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
 -- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
 
 CREATE   PROCEDURE [DBO].[SP_RWZI_CONNECTED_INHABITANTS]
 AS
 BEGIN
     INSERT INTO [VWSSTATIC].[RWZI_CONNECTED_INHABITANTS] (        
         [REGIO_CODE],
 	    [REGIO_NAME],
         [CONNECTED_INHABITANTS]
     )
     SELECT
         [REGIO_CODE],
 	    [REGIO_NAME],
         [CONNECTED_INHABITANTS]
     FROM [VWSSTAGE].[RWZI_CONNECTED_INHABITANTS]
     WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].[RWZI_CONNECTED_INHABITANTS] WITH(NOLOCK))
 END;