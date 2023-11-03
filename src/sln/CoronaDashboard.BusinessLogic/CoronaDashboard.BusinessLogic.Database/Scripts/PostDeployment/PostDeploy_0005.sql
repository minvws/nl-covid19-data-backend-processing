
declare @version0005 int = 5;
declare @description0005 nvarchar(max) = 'Reclassified Municipality Mapping';


if not exists (select * from  DACPAC_VERSION_HISTORY where DEPLOYMENT_VERSION = @version0005 and DEPLOYMENT_TYPE = 'Post')
    begin
		begin tran

		begin try

			print concat('Performing dacpac migration version [' , @version0005 , '] ' , @description0005)

			------- Non boiler plate actions:

            DELETE FROM VWSSTATIC.RECLASSIFIED_MUNICIPALITY_MAPPING
            INSERT INTO VWSSTATIC.RECLASSIFIED_MUNICIPALITY_MAPPING (GM_CODE_ORIGINAL,	[GM_NAME_ORIGINAL],GM_CODE_NEW,GM_NAME_NEW,VR_CODE, VR_NAME,PROVINCE_CODE,PROVINCE_NAME,GGD_CODE,GGD_NAME,SHARES,ACTIVE)
			VALUES ('GM1684','Cuijk','GM1982','Land van Cuijk','VR21','Brabant-Noord','PV30','Noord-Brabant','GG5406','GGD Hart voor Brabant',1,1)
				 , ('GM0756','Boxmeer','GM1982','Land van Cuijk','VR21','Brabant-Noord','PV30','Noord-Brabant','GG5406','GGD Hart voor Brabant',1,1)
				 , ('GM0815','Mill en Sint Hubert','GM1982','Land van Cuijk','VR21','Brabant-Noord','PV30','Noord-Brabant','GG5406','GGD Hart voor Brabant',1,1)
				 , ('GM1702','Sint Anthonis','GM1982','Land van Cuijk','VR21','Brabant-Noord','PV30','Noord-Brabant','GG5406','GGD Hart voor Brabant',1,1)
				 , ('GM0786','Grave','GM1982','Land van Cuijk','VR21','Brabant-Noord','PV30','Noord-Brabant','GG5406','GGD Hart voor Brabant',1,1)
				 , ('GM1685','Landerd','GM1991','Maashorst','VR21','Brabant-Noord','PV30','Noord-Brabant','GG5406','GGD Hart voor Brabant',1,1)
				 , ('GM0856','Uden','GM1991','Maashorst','VR21','Brabant-Noord','PV30','Noord-Brabant','GG5406','GGD Hart voor Brabant',1,1)
				 , ('GM0398','Heerhugowaard','GM1980','Dijk en Waard','VR10','Noord-Holland-Noord','PV27','Noord-Holland','GG2707','GGD Hollands-Noorden',1,1)
				 , ('GM0416','Langedijk','GM1980','Dijk en Waard','VR10','Noord-Holland-Noord','PV27','Noord-Holland','GG2707','GGD Hollands-Noorden',1,1)
				 , ('GM0370','Beemster','GM0439','Purmerend','VR11','Zaanstreek-Waterland','PV27','Noord-Holland','GG7306','GGD Zaanstreek/Waterland',1,1)
				 , ('GM0501','Brielle','GM1992','Voorne aan Zee','VR17','Rotterdam-Rijnmond','PV28','Zuid-Holland','GG4607','GGD Rotterdam-Rijnmond',1,1)
				 , ('GM0530','Hellevoetsluis','GM1992','Voorne aan Zee','VR17','Rotterdam-Rijnmond','PV28','Zuid-Holland','GG4607','GGD Rotterdam-Rijnmond',1,1)
				 , ('GM0614','Westvoorne','GM1992','Voorne aan Zee','VR17','Rotterdam-Rijnmond','PV28','Zuid-Holland','GG4607','GGD Rotterdam-Rijnmond',1,1)
				 , ('GM0457','Weesp','GM0363','Amsterdam','VR13','Amsterdam-Amstellan','PV27','Noord-Holland','GG3406','GGD Amsterdam',1,1);

			-------- end of non boiler plate stuff


			insert into DACPAC_VERSION_HISTORY (DEPLOYMENT_VERSION, DEPLOYMENT_TYPE, DEPLOYMENT_DESCRIPTION, INSTALLED_TIME) 
				values (@version0005, 'Post', @description0005 , getdate())
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
    print concat('Skipping dacpac migration version [' , @version0005 , ']')

