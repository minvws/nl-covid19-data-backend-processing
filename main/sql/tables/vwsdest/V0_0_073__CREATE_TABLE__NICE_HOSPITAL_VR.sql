-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_NICE_HOSPITAL_VR]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_NICE_HOSPITAL_VR
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSDEST.NICE_HOSPITAL_VR(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_NICE_HOSPITAL_VR]),
	DATE_OF_STATISTICS DATETIME NULL,
	VR_CODE VARCHAR(100) NULL,
	VR_NAME VARCHAR(100) NULL,
	REPORTED INT NULL,
	HOSPITALIZED INT NULL,
	HOSPITALIZED_3D_AVG DECIMAL(16,2) NULL,
	REPORTED_3D_AVG DECIMAL(16,2) NULL,
	HOSPITALIZED_CUMULATIVE INT NULL,
	REPORTED_CUMULATIVE INT NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE(),
	REPORTED_PER_MIL_LAST_WEEK INT NULL,
	WEEK_START DATETIME NULL,
	HOSPITALIZED_7D_AVG DECIMAL(16,2),
	WEEK_START_LAG DATETIME NULL,
	HOSPITALIZED_7D_AVG_LAG DECIMAL(16,2) NULL,
	REPORTED_7D_AVG DECIMAL(16,2) NULL,
	REPORTED_7D_AVG_LAG DECIMAL(16,2) NULL
);

CREATE NONCLUSTERED INDEX IX_NICE_HOSPITAL_VR_DEST
ON VWSDEST.NICE_HOSPITAL_VR(DATE_OF_STATISTICS, DATE_LAST_INSERTED, VR_CODE)
INCLUDE (HOSPITALIZED,HOSPITALIZED_3D_AVG,HOSPITALIZED_CUMULATIVE);