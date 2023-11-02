
declare @version0001 int = 1;
declare @description0001 nvarchar(max) = 'Initial deployment script run.';


if not exists (select * from  DACPAC_VERSION_HISTORY where DEPLOYMENT_VERSION = @version0001 and DEPLOYMENT_TYPE = 'Post')
    begin
		begin tran

		begin try

			print concat('Performing dacpac migration version [' , @version0001 , '] ' , @description0001)

			------- Non boiler plate actions:


			-- Start of insertion of data --

			SET IDENTITY_INSERT [DATATINO_1].[FLOW_ITEM_TYPES] ON

			if not exists (select * from [DATATINO_1].[FLOW_ITEM_TYPES])
				begin
					print 'Inserting [FLOW_ITEM_TYPES]'
					insert into  [DATATINO_1].[FLOW_ITEM_TYPES] ([ID], [DESCRIPTION], [NAME]) values 
						(1, 'Data Orchestration', 'FLOW'),
						(2, 'Data Ingestion/Movement Step', 'DATAFLOW'),
						(3, 'Data Extraction Step', 'PROTO'),
						(4, 'Miscellaneous Data Step', 'PIPELINE')
				end

			SET IDENTITY_INSERT [DATATINO_1].[FLOW_ITEM_TYPES] OFF


		
			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] ON

			if not exists (select * from [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES])
				begin
					print 'Inserting [DATAFLOW_TYPES]'
					insert into  [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] ([ID], [DESCRIPTION], [NAME]) values 
						(1, 'Main', 'Workflow'),
						(2, 'Step', 'Process')
				end

			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] OFF






			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[DELIMITER_TYPES] ON

			if not exists (select * from [DATATINO_ORCHESTRATOR_1].[DELIMITER_TYPES])
				begin
					print 'Inserting [DELIMITER_TYPES]'
					insert into  [DATATINO_ORCHESTRATOR_1].[DELIMITER_TYPES] ([ID], [DESCRIPTION], [NAME]) values 
						(1, 'Not Applicable', 'N/A'),
						(2, 'A file delimited by " "', 'Space'),
						(3, 'A file delimited by ","', 'Colon'),
						(4, 'A file delimited by ";"', 'SemiColon'),
						(5, 'A file delimited by "|"', 'Pipe')
				end

			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[DELIMITER_TYPES] OFF



			
			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[LOCATION_TYPES] ON


			if not exists (select * from [DATATINO_ORCHESTRATOR_1].[LOCATION_TYPES])
				begin
					print 'Inserting [LOCATION_TYPES]'
					insert into [DATATINO_ORCHESTRATOR_1].[LOCATION_TYPES] ([ID], [DESCRIPTION], [NAME]) values 			
						(1, 'Not Applicable', 'N/A'),
						(2, 'A source file that can be found by going to the specified URL in the source. File needs to be reachable by means of the URL', 'Web'),
						(3, 'A source file that can be found in an Azure Storage Account (Blob)', 'AzureBlob')						
				end

			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[LOCATION_TYPES] OFF
		
		



		
			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[SECURITY_PROFILE_TYPES] ON
		
			if not exists (select * from [DATATINO_ORCHESTRATOR_1].[SECURITY_PROFILE_TYPES])
				begin
					print 'Inserting [SECURITY_PROFILE_TYPES]'
					insert into [DATATINO_ORCHESTRATOR_1].[SECURITY_PROFILE_TYPES]([ID], [DESCRIPTION], [NAME]) values			
						(1, 'Not Applicable', 'NA'),
						(2, 'Authentication is done by means of a username and password, concatenated and pipe-delimited. E.g. <USERNAME>|<PASSWORD>', 'NETWORK_CREDENTIAL'),
						(3, 'Authentication is done by means of a Blob connection string', 'AZURE_BLOB'),
						(4, 'Authentication is done by means of a Database connection string: Server=tcp:<SERVER_NAME>,<PORT>;Initial Catalog=<DATABASE_NAME>;User ID=<USER_NAME;Password=<PASSWORD>;', 'SQL_SERVER'),
						(5, 'Authentication is done by means of a Bearer token that will be added to the Headers of the WebClient as follows: ''Bearer <TOKEN>''', 'BEARER')			
			
				end

			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[SECURITY_PROFILE_TYPES] OFF
		




		
			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[SOURCE_TYPES] ON
		
			if not exists (select * from [DATATINO_ORCHESTRATOR_1].[SOURCE_TYPES])
				begin
					print 'Inserting [SOURCE_TYPES]'
					insert into [DATATINO_ORCHESTRATOR_1].[SOURCE_TYPES]([ID], [DESCRIPTION], [NAME]) values
			
						(1, 'A SQL Server Stored Procedure ([SCHEMA].[SP_NAME])', 'StoredProcedure'),
						(2, 'A CSV file as source. Delimiter can be specified in the source', 'CsvFile'),
						(3, 'A JSON file, can be array based, object based or combined', 'JsonFile'),
						(4, 'A HTTP_POST request to be executed', 'HTTP_POST'),
						(5, 'Use this when the API you want to use restricts you in the number of records you may ingest. Pipe delimited, where the first URL is the count query, and the second the URL for the full dataset', 'RestrictedApi')			
			
				end

			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[SOURCE_TYPES] OFF
		
		




		
			SET IDENTITY_INSERT [DATATINO_PROTO_1].[LAYOUT_TYPES] ON
		
			if not exists (select * from [DATATINO_PROTO_1].[LAYOUT_TYPES])
				begin
					print 'Inserting [LAYOUT_TYPES]'
					insert into [DATATINO_PROTO_1].[LAYOUT_TYPES]([ID], [DESCRIPTION], [NAME]) values
			
						(1, 'Publishes the values, including an object representing the last value, based on the stated date key', 'LASTVALUE'),
						(2, 'Publishes only the values', 'VALUES'),
						(3, 'Publishes  an object representing the last value directly attached to the key', 'LASTVALUEDIRECT'),
						(4, 'Publishes the values, directly attached to the key', 'VALUESDIRECT'),
						(5, 'Publishes the first available record returned from the data source.', 'SINGLEVALUE'),
						(6, 'Publishes the first available record returned from the data source, directly attached to the key', 'SINGLEVALUE')			
			
				end

			SET IDENTITY_INSERT [DATATINO_PROTO_1].[LAYOUT_TYPES] OFF




			
			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[SECURITY_PROFILES] ON

			if not exists (select * from [DATATINO_ORCHESTRATOR_1].[SECURITY_PROFILES])
				begin
					print 'Inserting [SECURITY_PROFILES]'
					insert into [DATATINO_ORCHESTRATOR_1].[SECURITY_PROFILES]([ID],[SPT_ID], [ACTIVE], [DESCRIPTION], [NAME]) values
			
						(1, 1, 1, 'Not Applicable', 'N/A'),
						(2, 2, 1, 'Credentials for accessing the RIVM portal', 'RIVM')			
			
				end

			SET IDENTITY_INSERT [DATATINO_ORCHESTRATOR_1].[SECURITY_PROFILES] OFF




			-------- end of non boiler plate stuff


			insert into DACPAC_VERSION_HISTORY (DEPLOYMENT_VERSION, DEPLOYMENT_TYPE, DEPLOYMENT_DESCRIPTION, INSTALLED_TIME) 
				values (@version0001, 'Post', @description0001 , getdate())
		end try

		begin catch
			SELECT   
				ERROR_NUMBER() AS ErrorNumber  
				,ERROR_SEVERITY() AS ErrorSeverity  
				,ERROR_STATE() AS ErrorState  
				,ERROR_PROCEDURE() AS ErrorProcedure  
				,ERROR_LINE() AS ErrorLine  
				,ERROR_MESSAGE() AS ErrorMessage;

			if @@TRANCOUNT > 0
				rollback tran;
		end catch

		if @@TRANCOUNT > 0
			commit tran;
    end
else
    print concat('Skipping dacpac migration version [' , @version0001 , ']')

