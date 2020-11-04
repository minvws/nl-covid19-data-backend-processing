-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

exec [dbo].[SafeInsertProto] 'NL', 'name|code', 'NL|NL', 'true'
exec [dbo].[SafeInsertProto] 'VR01', 'name|code', 'VR01|VR01', 'true'
exec [dbo].[SafeInsertProto] 'VR02', 'name|code', 'VR02|VR02', 'true'
exec [dbo].[SafeInsertProto] 'VR03', 'name|code', 'VR03|VR03', 'true'
exec [dbo].[SafeInsertProto] 'VR04', 'name|code', 'VR04|VR04', 'true'
exec [dbo].[SafeInsertProto] 'VR05', 'name|code', 'VR05|VR05', 'true'
exec [dbo].[SafeInsertProto] 'VR06', 'name|code', 'VR06|VR06', 'true'
exec [dbo].[SafeInsertProto] 'VR07', 'name|code', 'VR07|VR07', 'true'
exec [dbo].[SafeInsertProto] 'VR08', 'name|code', 'VR08|VR08', 'true'
exec [dbo].[SafeInsertProto] 'VR09', 'name|code', 'VR09|VR09', 'true'
exec [dbo].[SafeInsertProto] 'VR10', 'name|code', 'VR10|VR10', 'true'
exec [dbo].[SafeInsertProto] 'VR11', 'name|code', 'VR11|VR11', 'true'
exec [dbo].[SafeInsertProto] 'VR12', 'name|code', 'VR12|VR12', 'true'
exec [dbo].[SafeInsertProto] 'VR13', 'name|code', 'VR13|VR13', 'true'
exec [dbo].[SafeInsertProto] 'VR14', 'name|code', 'VR14|VR14', 'true'
exec [dbo].[SafeInsertProto] 'VR15', 'name|code', 'VR15|VR15', 'true'
exec [dbo].[SafeInsertProto] 'VR16', 'name|code', 'VR16|VR16', 'true'
exec [dbo].[SafeInsertProto] 'VR17', 'name|code', 'VR17|VR17', 'true'
exec [dbo].[SafeInsertProto] 'VR18', 'name|code', 'VR18|VR18', 'true'
exec [dbo].[SafeInsertProto] 'VR19', 'name|code', 'VR19|VR19', 'true'
exec [dbo].[SafeInsertProto] 'VR20', 'name|code', 'VR20|VR20', 'true'
exec [dbo].[SafeInsertProto] 'VR21', 'name|code', 'VR21|VR21', 'true'
exec [dbo].[SafeInsertProto] 'VR22', 'name|code', 'VR22|VR22', 'true'
exec [dbo].[SafeInsertProto] 'VR23', 'name|code', 'VR23|VR23', 'true'
exec [dbo].[SafeInsertProto] 'VR24', 'name|code', 'VR24|VR24', 'true'
exec [dbo].[SafeInsertProto] 'VR25', 'name|code', 'VR25|VR25', 'true'
exec [dbo].[SafeInsertProto] 'RANGES', 'name|code', 'ranges|ra', 'true'

DECLARE @gmcode NVARCHAR(100)
DECLARE @getgmcode CURSOR
DECLARE @headervalues NVARCHAR(100)

SET @getgmcode = CURSOR FOR
SELECT distinct [GMCODE]
FROM [VWSSTATIC].[SAFETY_REGIONS_PER_MUNICIPAL]

OPEN @getgmcode
FETCH NEXT
FROM @getgmcode INTO @gmcode
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @headervalues = @gmcode + '|' + @gmcode
    exec [dbo].[SafeInsertProto] @gmcode, 'name|code', @headervalues, 'true'
    FETCH NEXT
    FROM @getgmcode INTO @gmcode
END

CLOSE @getgmcode
DEALLOCATE @getgmcode



GO