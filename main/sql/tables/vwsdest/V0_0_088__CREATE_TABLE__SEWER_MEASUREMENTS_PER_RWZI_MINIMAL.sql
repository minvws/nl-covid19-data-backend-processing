-- Copyright (c) 2020 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
-- Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2 - see https://github.com/minvws/nl-contact-tracing-app-coordination for more information.

IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_SEWER_MEASUREMENTS_PER_RWZI_MIN]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_SEWER_MEASUREMENTS_PER_RWZI_MIN
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE [VWSDEST].[SEWER_MEASUREMENTS_PER_RWZI_MINIMAL](
	[ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_SEWER_MEASUREMENTS_PER_RWZI_MIN]),
	[DATE_UNIX] [bigint] NULL,
	[DATE_START_UNIX] [bigint] NULL,
	[DATE_END_UNIX] [bigint] NULL,
	[WEEK] [int] NULL,
	[RWZI_AWZI_CODE] [varchar](100) NULL,
	[RWZI_AWZI_NAME] [varchar](100) NULL,
	[GMCODE] [varchar](100) NULL,
	[RNA_NORMALIZED] [decimal](16, 2) NULL,
	DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
) ON [PRIMARY]
GO
