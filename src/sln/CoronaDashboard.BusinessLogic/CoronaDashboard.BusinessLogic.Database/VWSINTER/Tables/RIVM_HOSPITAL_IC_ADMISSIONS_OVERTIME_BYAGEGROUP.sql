﻿CREATE TABLE [VWSINTER].[RIVM_HOSPITAL_IC_ADMISSIONS_OVERTIME_BYAGEGROUP] (
    [ID]                              INT           DEFAULT (NEXT VALUE FOR [DBO].[SEQ_VWSINTER_RIVM_HOSPITAL_IC_ADMISSIONS_OVERTIME_BYAGEGROUP]) NOT NULL,
    [VERSION]                         VARCHAR (100) NULL,
    [DATE_OF_REPORT]                  DATETIME      NULL,
    [DATE_OF_STATISTICS_WEEK_START]   DATE          NULL,
    [AGE_GROUP]                       VARCHAR (100) NULL,
    [HOSPITAL_ADMISSION_NOTIFICATION] INT           NULL,
    [HOSPITAL_ADMISSION]              INT           NULL,
    [IC_ADMISSION_NOTIFICATION]       INT           NULL,
    [IC_ADMISSION]                    INT           NULL,
    [DATE_LAST_INSERTED]              DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_INTER_RIVM_HOSPITAL_IC_ADMISSIONS_OVERTIME_BYAGEGROUP]
    ON [VWSINTER].[RIVM_HOSPITAL_IC_ADMISSIONS_OVERTIME_BYAGEGROUP]([DATE_LAST_INSERTED] ASC, [DATE_OF_STATISTICS_WEEK_START] ASC);

