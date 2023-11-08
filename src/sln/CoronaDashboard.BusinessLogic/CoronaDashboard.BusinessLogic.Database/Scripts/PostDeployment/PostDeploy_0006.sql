
declare @version0006 int = 6;
declare @description0006 nvarchar(max) = 'Calendar';


if not exists (select * from  DACPAC_VERSION_HISTORY where DEPLOYMENT_VERSION = @version0006 and DEPLOYMENT_TYPE = 'Post')
    begin
		begin tran

		begin try

			print concat('Performing dacpac migration version [' , @version0006 , '] ' , @description0006)

			------- Non boiler plate actions:

            EXEC [dbo].[SP_CALENDAR];

			-------- end of non boiler plate stuff


			insert into DACPAC_VERSION_HISTORY (DEPLOYMENT_VERSION, DEPLOYMENT_TYPE, DEPLOYMENT_DESCRIPTION, INSTALLED_TIME) 
				values (@version0006, 'Post', @description0006 , getdate())
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
    print concat('Skipping dacpac migration version [' , @version0006 , ']')

