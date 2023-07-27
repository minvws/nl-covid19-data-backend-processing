﻿CREATE TABLE [VWSSTAGE].[RIVM_VACCINATIONSTATUS_IC_ADMISSIONS] (
    [ID]                                  INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_VACCINATIONSTATUS_IC_ADMISSIONS]) NOT NULL,
    [DATE_START]                          VARCHAR (100) NULL,
    [DATE_END]                            VARCHAR (100) NULL,
    [GROUP_SIZE]                          VARCHAR (100) NULL,
    [FULLY_VACCINATED]                    VARCHAR (100) NULL,
    [FULLY_VACCINATED_PERCENTAGE]         VARCHAR (100) NULL,
    [PARTIALLY_NOT_VACCINATED]            VARCHAR (100) NULL,
    [PARTIALLY_NOT_VACCINATED_PERCENTAGE] VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]                  DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VWSSTAGE_VACCINATIONSTATUS_IC_ADMISSIONS]
    ON [VWSSTAGE].[RIVM_VACCINATIONSTATUS_IC_ADMISSIONS]([DATE_LAST_INSERTED] ASC);

