-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

CREATE TABLE VWSSTATIC.NURSING_HOME_LOCATIONS_PER_REGION(
	VRCODE VARCHAR(50) NOT NULL,
	VRNAAM VARCHAR(100) NOT NULL,
	-- Since these numbers are always used during divisions for calculating percentages making it a float already will prevent int division behaviour.
	VERPLEEGHUIZEN FLOAT NOT NULL,
	GEHANDICAPTENZORGINSTELLINGEN FLOAT NOT NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
)

GO

-- Insert regional records for amount of nursing homes as provided by VWS.
INSERT INTO VWSSTATIC.NURSING_HOME_LOCATIONS_PER_REGION(VRCODE,VRNAAM,VERPLEEGHUIZEN,GEHANDICAPTENZORGINSTELLINGEN) VALUES 
 ('VR01','Groningen',80,109)
,('VR02','Frysl�n',128,80)
,('VR03','Drenthe',99,98)
,('VR04','IJsselland',86,117)
,('VR05','Twente',114,129)
,('VR06','Noord- en Oost-Gelderland',157,244)
,('VR07','Gelderland-Midden',117,166)
,('VR08','Gelderland-Zuid',81,71)
,('VR09','Utrecht',187,176)
,('VR10','Noord-Holland-Noord',105,90)
,('VR11','Zaanstreek-Waterland',35,47)
,('VR12','Kennemerland',69,70)
,('VR13','Amsterdam-Amstelland',84,124)
,('VR14','Gooi en Vechtstreek',48,35)
,('VR15','Haaglanden',117,125)
,('VR16','Hollands-Midden',97,139)
,('VR17','Rotterdam-Rijnmond',147,255)
,('VR18','Zuid-Holland-Zuid',58,100)
,('VR19','Zeeland',85,58)
,('VR20','Midden- en West-Brabant',161,89)
,('VR21','Brabant-Noord',90,70)
,('VR22','Brabant-Zuidoost',101,30)
,('VR23','Limburg-Noord',78,36)
,('VR24','Limburg-Zuid',98,65)
,('VR25','Flevoland',29,64);

GO

-- Insert value for national which is the sum of all regions.
INSERT INTO VWSSTATIC.NURSING_HOME_LOCATIONS_PER_REGION(
	VRCODE,
	VRNAAM,
	VERPLEEGHUIZEN,
	GEHANDICAPTENZORGINSTELLINGEN) 
SELECT 
	'NL' AS VRCODE,
	'Nederland' AS VRNAAM,
	SUM(VERPLEEGHUIZEN) AS VERPLEEGHUIZEN,
	SUM(GEHANDICAPTENZORGINSTELLINGEN)AS GEHANDICAPTENZORGINSTELLINGEN
    FROM ( 
		SELECT 
			VRCODE, 
			VRNAAM, 
			VERPLEEGHUIZEN, 
			GEHANDICAPTENZORGINSTELLINGEN,
			RANK() OVER (PARTITION BY VRCODE ORDER BY DATE_LAST_INSERTED DESC) RANK_ORDER
			FROM [VWSSTATIC].[NURSING_HOME_LOCATIONS_PER_REGION]
	) T1 WHERE RANK_ORDER = 1

GO

-- View for only selecting the values that were inserted last.
CREATE OR ALTER VIEW [VWSSTATIC].[V_NURSING_HOME_LOCATIONS_PER_REGION] AS
SELECT 
	VRCODE,
	VRNAAM,
	VERPLEEGHUIZEN,
	GEHANDICAPTENZORGINSTELLINGEN,
	DATE_LAST_INSERTED
    FROM ( 
		SELECT 
			VRCODE, 
			VRNAAM, 
			VERPLEEGHUIZEN, 
			GEHANDICAPTENZORGINSTELLINGEN,
			DATE_LAST_INSERTED,
			RANK() OVER (PARTITION BY VRCODE ORDER BY DATE_LAST_INSERTED DESC) RANK_ORDER
			FROM [VWSSTATIC].[NURSING_HOME_LOCATIONS_PER_REGION]
	) T1 WHERE RANK_ORDER = 1