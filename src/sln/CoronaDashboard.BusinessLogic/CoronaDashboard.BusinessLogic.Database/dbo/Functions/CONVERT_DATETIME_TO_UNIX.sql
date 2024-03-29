﻿-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
 -- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.
 
 CREATE   FUNCTION [dbo].[CONVERT_DATETIME_TO_UNIX] (@input DATETIME)
 RETURNS BIGINT
 AS BEGIN
     DECLARE @work BIGINT
     -- set @work = DATEDIFF(SECOND,{d '1970-01-01'}, convert(datetime, @input, 101))
     set @work = DATEDIFF_BIG(SECOND,{d '1970-01-01'}, convert(datetime, @input, 101))
     RETURN @work
 END;
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[CONVERT_DATETIME_TO_UNIX] TO [db_execute_functions]
    AS [dbo];

