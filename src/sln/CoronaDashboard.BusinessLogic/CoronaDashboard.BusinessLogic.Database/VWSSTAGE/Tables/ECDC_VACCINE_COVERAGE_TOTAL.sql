﻿CREATE TABLE [VWSSTAGE].[ECDC_VACCINE_COVERAGE_TOTAL] (
    [ID]                             INT           DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_ECDC_VACCINE_COVERAGE_TOTAL]) NOT NULL,
    [VERSION]                        VARCHAR (100) NULL,
    [DATE_OF_REPORT]                 VARCHAR (100) NULL,
    [DATE_OF_STATISTICS]             VARCHAR (100) NULL,
    [BIRTH_YEAR]                     VARCHAR (100) NULL,
    [VACCINATION_COVERAGE_PARTLY]    VARCHAR (100) NULL,
    [VACCINATION_COVERAGE_COMPLETED] VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]             DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY NONCLUSTERED ([ID] ASC)
);


GO
CREATE CLUSTERED INDEX [CI_DLI_VWSSTAGE_ECDC_VACCINE_COVERAGE_TOTAL]
    ON [VWSSTAGE].[ECDC_VACCINE_COVERAGE_TOTAL]([DATE_LAST_INSERTED] ASC);

