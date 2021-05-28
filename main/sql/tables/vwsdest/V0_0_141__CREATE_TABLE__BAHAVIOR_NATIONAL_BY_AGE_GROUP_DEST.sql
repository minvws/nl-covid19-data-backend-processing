-- Copyright (c) 2021 De Staat der Nederlanden, Ministerie van   Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordinationfor more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_BEHAVIOR_NATIONAL_BY_AGE_GROUP]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_BEHAVIOR_NATIONAL_BY_AGE_GROUP
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE [VWSDEST].[BEHAVIOR_NATIONAL_BY_AGE_GROUP](
  [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_BEHAVIOR_NATIONAL_BY_AGE_GROUP]),
	[DATE_OF_REPORT] [datetime] NULL,
	[DATE_OF_MEASUREMENT] [datetime] NULL,
	[WAVE] [int] NULL,
	[REGION_CODE] [varchar](100) NULL,
	[SUBGROUP_CATEGORY] [varchar](100) NULL,
	[SUBGROUP] [varchar](100) NULL,
	[INDICATOR_CATEGORY] [varchar](100) NULL,
	[INDICATOR] [varchar](100) NULL,
	[SAMPLE_SIZE] [int] NULL,
	[FIGURE_TYPE] [varchar](100) NULL,
	[VALUE] int NULL,
  	[DATE_LAST_INSERTED]  DATETIME DEFAULT GETDATE()
)