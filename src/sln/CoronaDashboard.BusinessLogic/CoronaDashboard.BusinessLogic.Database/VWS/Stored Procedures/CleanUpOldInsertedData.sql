CREATE PROCEDURE [dbo].[CleanUpOldInsertedData]
    @maxHistory int = 10
AS
	declare @schemaName varchar(200);
	declare @tableName varchar(200);
	declare @sqlString NVARCHAR(MAX);

	declare cur cursor for
		select 
			s.[Name] as SchemaName, 
			t.[Name] as TableName  
		from sys.tables t
			left join sys.schemas s on t.schema_id = s.schema_id 
		where s.name in (
			'VWSARCHIVE',
			'VWSDEST',
			'VWSINTER',
			'VWSSTAGE',
			'VWSSTATIC'	
		)
		order by s.Name, t.name

	open cur

	fetch next from cur
	into @schemaName, @tableName

	while @@FETCH_STATUS = 0
		begin
			set @sqlString =  concat('
				declare @batchSize int = 1000000
				declare @currentBatch int = 0
				
				while 1 = 1
				begin
					set @currentBatch = @currentBatch + 1
					print concat(format (getdate(),''yyyy-MM-dd hh:mm:ss'') , '' | Deleting batch '', @currentBatch, '' of max '', @batchSize, '' rows'');
					RAISERROR( ''...'',0,1) WITH NOWAIT
					delete top (@batchSize) 
					from [',@schemaName,'].[',@tableName,']
					where DATE_LAST_INSERTED not in (
						select distinct top ', @maxHistory, ' DATE_LAST_INSERTED 
						from [',@schemaName,'].[',@tableName,']
						order by DATE_LAST_INSERTED desc);
					if @@rowcount < @batchSize break
				end
				'); 	
			print '------------------------------------------'
			print concat(format (getdate(),'yyyy-MM-dd hh:mm:ss') , ' | Removing entries from [',@schemaName,'].[',@tableName,']');
			RAISERROR( '...',0,1) WITH NOWAIT
			execute sp_executesql @sqlString 

			print concat(format (getdate(),'yyyy-MM-dd hh:mm:ss') , ' | Done removing entries from [',@schemaName,'].[',@tableName,']');

			fetch next from cur
			into @schemaName, @tableName
		end;
	close cur;
	deallocate cur;
RETURN 0
