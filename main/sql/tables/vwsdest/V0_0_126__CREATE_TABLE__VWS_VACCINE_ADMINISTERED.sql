-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_VACCINE_ADMINISTERED]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_VACCINE_ADMINISTERED
  START WITH 1
  INCREMENT BY 1;
GO


CREATE TABLE VWSDEST.VWS_VACCINE_ADMINISTERED
(
   [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_VACCINE_ADMINISTERED])
  ,[DATE_FIRST_DAY]   DATETIME NULL
  ,DATE_START_UNIX    BIGINT NULL
  ,DATE_END_UNIX      BIGINT NULL
  ,[VALUE_TYPE]       VARCHAR(100) NULL
  ,[REPORT_STATUS]    VARCHAR(100) NULL
  ,[AstraZeneca]      BIGINT NULL
  ,[BioNTech/Pfizer]  BIGINT NULL
  ,[CureVac]          BIGINT NULL
  ,[Janssen]          BIGINT NULL
  ,[Moderna]          BIGINT NULL
  ,[Sanofi]           BIGINT NULL
  ,[DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
);


CREATE NONCLUSTERED INDEX IX_DEST_VWS_VACCINE_ADMINISTERED
ON VWSDEST.VWS_VACCINE_ADMINISTERED (DATE_LAST_INSERTED)
INCLUDE (
   [DATE_FIRST_DAY]
  ,DATE_START_UNIX
  ,DATE_END_UNIX
  ,[VALUE_TYPE]
  ,[REPORT_STATUS]
  ,[AstraZeneca]    
  ,[BioNTech/Pfizer]
  ,[CureVac]        
  ,[Janssen]        
  ,[Moderna]        
  ,[Sanofi]         
  );
