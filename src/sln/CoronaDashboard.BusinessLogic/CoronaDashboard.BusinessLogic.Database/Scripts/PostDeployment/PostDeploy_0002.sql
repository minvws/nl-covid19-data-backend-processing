
declare @version0002 int = 2;
declare @description0002 nvarchar(max) = 'Static ADF file configurations';


if not exists (select * from  DACPAC_VERSION_HISTORY where DEPLOYMENT_VERSION = @version0002 and DEPLOYMENT_TYPE = 'Post')
    begin
		begin tran

		begin try

			print concat('Performing dacpac migration version [' , @version0002 , '] ' , @description0002)

			------- Non boiler plate actions:
            TRUNCATE TABLE [VWSSTATIC].[SPLIT_FILE_SOURCES]

			DECLARE @Source_content_url nvarchar(200) = 'https://data.rivm.nl/data/vws/covid-19/'
            DECLARE @Source_content nvarchar(200) = 'COVID-19_aantallen_gemeente_per_dag_tm_03102021.csv' 
            DECLARE @Target_Name nvarchar(200) = 'RIVM_COVID_19_NUMBER_MUNICIPALITY'
            DECLARE @ColumnMappingSource nvarchar(1024) = 'DATE_LAST_INSERTED|Date_of_report|Date_of_publication|Municipality_code|Municipality_name|Province|Security_region_code|Security_region_name|Municipal_health_service|ROAZ_region|Total_reported|Deceased'
            DECLARE @ColumnMappingTarget nvarchar(1024) = 'DATE_LAST_INSERTED|DATE_OF_REPORT|DATE_OF_PUBLICATION|MUNICIPALITY_CODE|MUNICIPALITY_NAME|PROVINCE|SECURITY_REGION_CODE|SECURITY_REGION_NAME|MUNICIPAL_HEALTH_SERVICE|ROAZ_REGION|TOTAL_REPORTED|DECEASED'
            Execute dbo.Add_Static_ADF_File @Source_content_url, @Source_content, 'VWSSTATIC', @Target_Name, @ColumnMappingSource, @ColumnMappingTarget 


            SET @Source_content = 'COVID-19_gehandicaptenzorg_tm_03102021.csv' 
            SET @Target_Name = 'DISABILITY'
            SET @ColumnMappingSource = 'DATE_LAST_INSERTED|Date_of_report|Date_of_statistic_reported|Security_region_code|Security_region_name|Total_cases_reported|Total_deceased_reported|Total_new_infected_locations_reported|Total_infected_locations_reported'
            SET @ColumnMappingTarget = 'Date_Last_Inserted|DATE_OF_REPORT|DATE_OF_STATISTIC_REPORTED|SECURITY_REGION_CODE|SECURITY_REGION_NAME|TOTAL_CASES_REPORTED|TOTAL_DECEASED_REPORTED|TOTAL_NEW_INFECTED_LOCATIONS_REPORTED|TOTAL_INFECTED_LOCATIONS_REPORTED'
            Execute dbo.Add_Static_ADF_File @Source_content_url, @Source_content, 'VWSSTATIC', @Target_Name, @ColumnMappingSource, @ColumnMappingTarget 


            SET @Source_content = 'COVID-19_thuiswonend_70plus_tm_03102021.csv' 
            SET @Target_Name = 'ELDERLY_AT_HOME'
            SET @ColumnMappingSource = 'DATE_LAST_INSERTED|Date_of_report|Date_of_statistic_reported|Security_region_code|Security_region|Total_cases_reported|Total_deceased_reported'
            SET @ColumnMappingTarget = 'DATE_LAST_INSERTED|DATE_OF_REPORT|DATE_OF_STATISTIC_REPORTED|SECURITY_REGION_CODE|SECURITY_REGION|TOTAL_CASES_REPORTED|TOTAL_DECEASED_REPORTED'
            Execute dbo.Add_Static_ADF_File @Source_content_url, @Source_content, 'VWSSTATIC', @Target_Name, @ColumnMappingSource, @ColumnMappingTarget 


            SET @Source_content = 'COVID-19_uitgevoerde_testen_tm_03102021.csv' 
            SET @Target_Name = 'GGD_TESTED_PEOPLE'
            SET @ColumnMappingSource = 'DATE_LAST_INSERTED|Version|Date_of_report|Date_of_statistics|Security_region_code|Security_region_name|Tested_with_result|Tested_positive'
            SET @ColumnMappingTarget = 'DATE_LAST_INSERTED|VERSION|DATE_OF_REPORT|DATE_OF_STATISTICS|SECURITY_REGION_CODE|SECURITY_REGION_NAME|TESTED_WITH_RESULT|TESTED_POSITIVE'
            Execute dbo.Add_Static_ADF_File @Source_content_url, @Source_content, 'VWSSTATIC', @Target_Name, @ColumnMappingSource, @ColumnMappingTarget 


            SET @Source_content = 'COVID-19_verpleeghuizen_tm_03102021.csv' 
            SET @Target_Name = 'RIVM_NURSING_HOMES_COMBINED'
            SET @ColumnMappingSource = 'DATE_LAST_INSERTED|Date_of_report|Date_of_statistic_reported|Security_region_code|Total_cases_reported|Total_deceased_reported|Total_new_infected_locations_reported|Total_infected_locations_reported'
            SET @ColumnMappingTarget = 'DATE_LAST_INSERTED|DATE_OF_REPORT|DATE_OF_STATISTIC_REPORTED|SECURITY_REGION_CODE|TOTAL_CASES_REPORTED|TOTAL_DECEASED_REPORTED|TOTAL_NEW_INFECTED_LOCATIONS_REPORTED|TOTAL_INFECTED_LOCATIONS_REPORTED'
            Execute dbo.Add_Static_ADF_File @Source_content_url, @Source_content, 'VWSSTATIC', @Target_Name, @ColumnMappingSource, @ColumnMappingTarget 


            SET @Source_content = 'COVID-19_reproductiegetal_tm_03102021.json' 
            SET @Target_Name = 'RIVM_REPRODUCTION_NUMBER'
            SET @ColumnMappingSource = 'DATE_LAST_INSERTED|Date|Rt_low|Rt_avg|Rt_up|population'
            SET @ColumnMappingTarget = 'DATE_LAST_INSERTED|DATE|RT_LOW|RT_AVG|RT_UP|POPULATION'
            Execute dbo.Add_Static_ADF_File @Source_content_url, @Source_content, 'VWSSTATIC', @Target_Name, @ColumnMappingSource, @ColumnMappingTarget 


            SET @Source_content = 'COVID-19_ic_opnames_tm_03102021.csv' 
            SET @Target_Name = 'RIVM_IC_OPNAME'
            SET @ColumnMappingSource = 'DATE_LAST_INSERTED|Version|Date_of_report|Date_of_statistics|IC_admission_notification|IC_admission'
            SET @ColumnMappingTarget = 'DATE_LAST_INSERTED|VERSION|DATE_OF_REPORT|DATE_OF_STATISTICS|IC_ADMISSION_NOTIFICATION|IC_ADMISSION'
            Execute dbo.Add_Static_ADF_File @Source_content_url, @Source_content, 'VWSSTATIC', @Target_Name, @ColumnMappingSource, @ColumnMappingTarget 


            SET @Source_content = 'COVID-19_ziekenhuisopnames_tm_03102021.csv' 
            SET @Target_Name = 'NICE_HOSPITAL'
            SET @ColumnMappingSource = 'DATE_LAST_INSERTED|Version|Date_of_report|Date_of_statistics|Municipality_code|Municipality_name|Security_region_code|Security_region_name|Hospital_admission_notification|Hospital_admission'
            SET @ColumnMappingTarget = 'DATE_LAST_INSERTED|VERSION|DATE_OF_REPORT|DATE_OF_STATISTICS|MUNICIPALITY_CODE|MUNICIPALITY_NAME|SECURITY_REGION_CODE|SECURITY_REGION_NAME|HOSPITAL_ADMISSION_NOTIFICATION|HOSPITAL_ADMISSION'
            Execute dbo.Add_Static_ADF_File @Source_content_url, @Source_content, 'VWSSTATIC', @Target_Name, @ColumnMappingSource, @ColumnMappingTarget 


            SET @Source_content = 'COVID-19_ziekenhuis_ic_opnames_per_leeftijdsgroep_tm_03102021.csv' 
            SET @Target_Name = 'RIVM_HOSPITAL_IC_ADMISSIONS_OVERTIME_BYAGEGROUP'
            SET @ColumnMappingSource = 'DATE_LAST_INSERTED|Version|Date_of_report|Date_of_statistics_week_start|Age_group|Hospital_admission_notification|Hospital_admission|IC_admission_notification|IC_admission'
            SET @ColumnMappingTarget = 'DATE_LAST_INSERTED|VERSION|DATE_OF_REPORT|DATE_OF_STATISTICS_WEEK_START|AGE_GROUP|HOSPITAL_ADMISSION_NOTIFICATION|HOSPITAL_ADMISSION|IC_ADMISSION_NOTIFICATION|IC_ADMISSION'
            Execute dbo.Add_Static_ADF_File @Source_content_url, @Source_content, 'VWSSTATIC', @Target_Name, @ColumnMappingSource, @ColumnMappingTarget 


			-------- end of non boiler plate stuff


			insert into DACPAC_VERSION_HISTORY (DEPLOYMENT_VERSION, DEPLOYMENT_TYPE, DEPLOYMENT_DESCRIPTION, INSTALLED_TIME) 
				values (@version0002, 'Post', @description0002 , getdate())
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
    print concat('Skipping dacpac migration version [' , @version0002 , ']')

