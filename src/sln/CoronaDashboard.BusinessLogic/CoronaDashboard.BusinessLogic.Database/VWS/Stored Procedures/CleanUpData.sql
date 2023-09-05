CREATE PROCEDURE [dbo].[CleanUpData]
    @maxHistory int = 10
AS
	declare @schemaName varchar(100);
	declare @tableName varchar(100);
	declare @sqlString NVARCHAR(500);

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
			set @sqlString =  concat(
				'with cte as (
			
					select distinct top ', @maxHistory, ' DATE_LAST_INSERTED 
					from [',@schemaName,'].[',@tableName,']
					order by DATE_LAST_INSERTED desc
			
				) 
				delete from [',@schemaName,'].[',@tableName,']
				where date_last_inserted not in (select date_last_inserted from cte)'); 	
			
			execute sp_executesql @sqlString 
			fetch next from cur
			into @schemaName, @tableName
		end;
	close cur;
	deallocate cur;
RETURN 0
