CREATE TABLE [VWSINTER].[RIVM_VACCINATIONS_PARTLY_FULLY] (
    [ID]                           INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_RIVM_VACCINATIONS_PARTLY_FULLY]) NOT NULL,
    [RECORDID]                     VARCHAR (100) NULL,
    [REPORTINGCOUNTRY]             VARCHAR (100) NULL,
    [RECORDTYPE]                   VARCHAR (100) NULL,
    [RECORDTYPEVERSION]            VARCHAR (100) NULL,
    [SUBJECT]                      VARCHAR (100) NULL,
    [DATASOURCE]                   VARCHAR (100) NULL,
    [STATUS]                       VARCHAR (100) NULL,
    [DATEUSEDFORSTATISTICS]        VARCHAR (100) NULL,
    [REGION]                       VARCHAR (100) NULL,
    [VACCINE]                      VARCHAR (100) NULL,
    [NUMBERDOSESRECEIVED]          INT           NULL,
    [TARGETGROUP]                  VARCHAR (100) NULL,
    [DOSEFIRST]                    INT           NULL,
    [DOSESECOND]                   INT           NULL,
    [DOSEUNK]                      INT           NULL,
    [DOSEFIRSTREFUSED]             VARCHAR (100) NULL,
    [DENOMINATOR]                  VARCHAR (100) NULL,
    [TARGETGROUPCOMMENT]           VARCHAR (100) NULL,
    [GENERALCOMMENT]               VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]           DATETIME      DEFAULT (getdate()) NULL,
    [DATE_OF_REPORT]               DATETIME      NULL,
    [DATE_OF_STATISTICS]           DATETIME      NULL,
    [END_ISO_WEEK]                 DATETIME      NULL,
    [BIRTH_YEAR]                   VARCHAR (100) NULL,
    [CUMSUM_VACCINATION_PARTLY]    INT           NULL,
    [CUMSUM_VACCINATION_COMPLETED] INT           NULL,
    [POPULATION]                   VARCHAR (100) NULL,
    [CUMSUM_VACCINATION_BOOSTER]   INT           NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_RIVM_VACCINATIONS_PARTLY_FULLY]
    ON [VWSINTER].[RIVM_VACCINATIONS_PARTLY_FULLY]([DATE_LAST_INSERTED] ASC);

