-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport. 
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.
-- Table for raw input of sewage measurements

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSINTER_RIVM_SEWER_MEASUREMENTS]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSINTER_RIVM_SEWER_MEASUREMENTS
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSINTER.RIVM_SEWER_MEASUREMENTS(
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_SEWER_MEASUREMENTS]),
	DATE_MEASUREMENT DATETIME,
  RWZI_AWZI_CODE BIGINT,
  RWZI_AWZI_NAME VARCHAR(100) NULL,
  X_COORDINATE DECIMAL(16,2) NULL,
  Y_COORDINATE DECIMAL(16,2) NULL,
  POSTAL_CODE VARCHAR(100) NULL,
  SECURITY_REGION_CODE VARCHAR(100),
  SECURITY_REGION_NAME VARCHAR(100),
  PERCENTAGE_IN_SECURITY_REGION FLOAT,
  RNA_PER_ML BIGINT,
  REPRESENTATIVE_MEASUREMENT VARCHAR(100) NULL,
	[DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
);