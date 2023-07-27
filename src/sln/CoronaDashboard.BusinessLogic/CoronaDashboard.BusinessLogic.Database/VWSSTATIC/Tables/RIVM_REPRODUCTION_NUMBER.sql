CREATE TABLE [VWSSTATIC].[RIVM_REPRODUCTION_NUMBER] (
    [ID]                 INT           IDENTITY (1, 1) NOT NULL,
    [DATE]               VARCHAR (100) NULL,
    [RT_LOW]             VARCHAR (100) NULL,
    [RT_AVG]             VARCHAR (100) NULL,
    [RT_UP]              VARCHAR (100) NULL,
    [POPULATION]         VARCHAR (100) NULL,
    [DATE_LAST_INSERTED] DATETIME      DEFAULT (getdate()) NULL,
    [VERSION]            VARCHAR (20)  NULL
);

