﻿CREATE TABLE [VWSDEST].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023] (
    [ID]                                INT             IDENTITY (1, 1) NOT NULL,
    [DATE_LAST_INSERTED]                DATETIME        DEFAULT (getdate()) NOT NULL,
    [DATE_OF_REPORT]                    DATETIME        NULL,
    [DATE_OF_REPORT_UNIX]               BIGINT          NULL,
    [IC_BEDS_OCCUPIED_COVID]            INT             NULL,
    [IC_BEDS_OCCUPIED_NON_COVID]        INT             NULL,
    [IC_BEDS_OCCUPIED_COVID_PERCENTAGE] DECIMAL (16, 2) NULL,
    [NON_IC_BEDS_OCCUPIED_COVID]        INT             NULL,
    [IC_INFLUX_COVID]                   INT             NULL,
    [NON_IC_INFLUX_COVID]               INT             NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [NCIX_LNAZ_HOSPITAL_BED_OCCUPANCY_2023]
    ON [VWSDEST].[LNAZ_HOSPITAL_BED_OCCUPANCY_2023]([DATE_LAST_INSERTED] ASC);

