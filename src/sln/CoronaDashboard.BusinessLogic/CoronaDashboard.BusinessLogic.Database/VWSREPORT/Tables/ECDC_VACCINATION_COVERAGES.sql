﻿CREATE TABLE [VWSREPORT].[ECDC_VACCINATION_COVERAGES] (
    [ID]                      INT             IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED]      DATETIME        DEFAULT (getdate()) NULL,
    [REPORTING_COUNTRY]       VARCHAR (100)   NULL,
    [UPTAKE_ONE_VACCINE_DOSE] DECIMAL (18, 1) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_RC_UOVD_ECDC_VACCINATION_COVERAGES]
    ON [VWSREPORT].[ECDC_VACCINATION_COVERAGES]([REPORTING_COUNTRY] ASC, [UPTAKE_ONE_VACCINE_DOSE] ASC);

