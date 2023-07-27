CREATE TABLE [VWSSTATIC].[RECODE_MUNICIPALITY] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [GMCODE_ORIGINEEL]   NVARCHAR (10)   NULL,
    [GMNAAM_ORIGINEEL]   NVARCHAR (255)  NULL,
    [GMCODE_NIEUW]       NVARCHAR (10)   NULL,
    [GMNAAM_NIEUW]       NVARCHAR (255)  NULL,
    [VRCODE]             NVARCHAR (10)   NULL,
    [VRNAAM]             NVARCHAR (255)  NULL,
    [PROVCODE]           NVARCHAR (10)   NULL,
    [PROVNAAM]           NVARCHAR (255)  NULL,
    [GGDCODE]            NVARCHAR (10)   NULL,
    [GGDNAAM]            NVARCHAR (255)  NULL,
    [AANDEEL]            DECIMAL (16, 6) DEFAULT ((1.0)) NOT NULL,
    [ACTIVE]             INT             DEFAULT ((0)) NOT NULL,
    [DATE_LAST_INSERTED] DATETIME        DEFAULT (getdate()) NOT NULL
);

