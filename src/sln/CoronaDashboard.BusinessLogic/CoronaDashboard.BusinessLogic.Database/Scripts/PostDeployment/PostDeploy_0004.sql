
declare @version0004 int = 4;
declare @description0004 nvarchar(max) = 'Holidays';


if not exists (select * from  DACPAC_VERSION_HISTORY where DEPLOYMENT_VERSION = @version0004 and DEPLOYMENT_TYPE = 'Post')
    begin
		begin tran

		begin try

			print concat('Performing dacpac migration version [' , @version0004 , '] ' , @description0004)

			------- Non boiler plate actions:

            INSERT INTO [VWSSTATIC].[HOLIDAYS_NL]
            VALUES
                ('2022-04-17','Eerste paasdag','Eerste paasdag'),
                ('2022-04-18','Tweede paasdag','Tweede paasdag'),
                ('2022-04-27','Koningsdag','Koningsdag'),
                ('2022-05-05','Bevrijdingsdag','Bevrijdingsdag'),
                ('2022-05-26','Hemelvaartsdag','Hemelvaartsdag'),
                ('2022-06-05','Eerste pinksterdag','Eerste pinksterdag'),
                ('2022-06-06','Tweede pinksterdag','Tweede pinksterdag'),
                ('2022-12-25','Eerste Kerstdag','Eerste Kerstdag'),
                ('2022-12-26','Tweede Kerstdag','Tweede Kerstdag'),
                ('2023-01-01','Nieuwjaarsdag','Nieuwjaarsdag'),
                ('2023-04-09','Eerste paasdag','Eerste paasdag'),
                ('2023-04-10','Tweede paasdag','Tweede paasdag'),
                ('2023-04-27','Koningsdag','Koningsdag'),
                ('2023-05-05','Bevrijdingsdag','Bevrijdingsdag'),
                ('2023-05-18','Hemelvaartsdag','Hemelvaartsdag'),
                ('2023-05-28','Eerste pinksterdag','Eerste pinksterdag'),
                ('2023-05-29','Tweede pinksterdag','Tweede pinksterdag'),
                ('2023-12-25','Eerste Kerstdag','Eerste Kerstdag'),
                ('2023-12-26','Tweede Kerstdag','Tweede Kerstdag'),
                ('2024-01-01','Nieuwjaarsdag', 'Nieuwjaarsdag');

			-------- end of non boiler plate stuff


			insert into DACPAC_VERSION_HISTORY (DEPLOYMENT_VERSION, DEPLOYMENT_TYPE, DEPLOYMENT_DESCRIPTION, INSTALLED_TIME) 
				values (@version0004, 'Post', @description0004 , getdate())
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
    print concat('Skipping dacpac migration version [' , @version0004 , ']')

