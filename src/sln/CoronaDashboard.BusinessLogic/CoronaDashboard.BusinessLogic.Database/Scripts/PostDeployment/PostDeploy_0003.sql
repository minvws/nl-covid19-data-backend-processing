
declare @version0003 int = 3;
declare @description0003 nvarchar(max) = 'Age group mappings';


if not exists (select * from  DACPAC_VERSION_HISTORY where DEPLOYMENT_VERSION = @version0003 and DEPLOYMENT_TYPE = 'Post')
    begin
		begin tran

		begin try

			print concat('Performing dacpac migration version [' , @version0003 , '] ' , @description0003)

			------- Non boiler plate actions:

            -- [VWSSTATIC].[COHORT_TO_AGE_GROUPS_MAPPING]
            DELETE FROM [VWSSTATIC].[COHORT_TO_AGE_GROUPS_MAPPING]
            INSERT INTO [VWSSTATIC].[COHORT_TO_AGE_GROUPS_MAPPING] (
                [COHORT],
                [AGE_GROUP]
            )
            VALUES
                -- 2021
                ('<=1940','81+'),
                ('1941-1950','71-80'),
                ('1951-1960','61-70'),
                ('1961-1970','51-60'),
                ('1971-1980','41-50'),
                ('1981-1990','31-40'),
                ('1991-2003','18-30'),
                ('2004-2009','12-17'),
                ('2010-2016','5-11'),
                ('<=2003','18+'),
                ('<2004','18+'),
                ('<=2009','12+'),
                ('<=2016','5+'),
                -- 2022
                ('<=1941','81+'),
                ('1942-1951','71-80'),
                ('1952-1961','61-70'),
                ('1962-1971','51-60'),
                ('1972-1981','41-50'),
                ('1982-1991','31-40'),
                ('1992-2004','18-30'),
                ('2005-2010','12-17'),
                ('2011-2017','5-11'),
                ('<=2004','18+'),
                ('<2005','18+'),
                ('<=2010','12+'),
                ('<=2017','5+'),
                -- 2022 v2
                ('<=1942','80+') ,
                ('1943-1952','70-79') ,
                ('1953-1962','60-69') ,
                ('1963-1972','50-59') ,
                ('1973-1982','40-49') ,
                ('1983-1992','30-39') ,
                ('1993-2004','18-29') ,
                ('Unknown','Unknown') ,
                -- 2022 v3
                ('<1962', '60+') ,
                ('<=1962', '60+');

            -- [VWSSTATIC].[COHORT_TO_NAMES_MAPPING]
            DELETE FROM [VWSSTATIC].[COHORT_TO_NAMES_MAPPING]
            INSERT INTO [VWSSTATIC].[COHORT_TO_NAMES_MAPPING] (
                [COHORT_ORIGINAL],
                [COHORT_ADJUSTED]
            )
            VALUES
                -- 2021
                (N'<=1940', N'-1940'),
                (N'<=2003', N'-2003'),
                (N'<2004', N'-2003'),
                (N'<=2009', N'-2009'),
                (N'<=2016', N'-2016'),
                -- 2022
                (N'<=1941', N'-1941'),
                (N'<=2004', N'-2004'),
                (N'<2005', N'-2004'),
                (N'<=2010', N'-2010'),
                (N'<=2017', N'-2017'),
                -- 2022 v2
                (N'<=1942',N'-1942'),
                -- 2022 v3
                (N'<1962',N'-1962') , 
                (N'<=1962',N'-1962');

			-------- end of non boiler plate stuff


			insert into DACPAC_VERSION_HISTORY (DEPLOYMENT_VERSION, DEPLOYMENT_TYPE, DEPLOYMENT_DESCRIPTION, INSTALLED_TIME) 
				values (@version0003, 'Post', @description0003 , getdate())
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
    print concat('Skipping dacpac migration version [' , @version0003 , ']')

