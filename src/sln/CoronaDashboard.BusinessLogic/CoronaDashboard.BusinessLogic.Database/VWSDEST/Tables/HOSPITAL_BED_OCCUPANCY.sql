﻿CREATE TABLE [VWSDEST].[HOSPITAL_BED_OCCUPANCY] (
    [ID]                                INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_HOSPITAL_BED_OCCUPANCY]) NOT NULL,
    [DATE_OF_REPORT]                    DATETIME        NULL,
    [DATE_OF_REPORT_UNIX]               BIGINT          NULL,
    [IC_BEDS_OCCUPIED_COVID]            INT             NULL,
    [IC_BEDS_OCCUPIED_NON_COVID]        INT             NULL,
    [IC_BEDS_OCCUPIED_COVID_PERCENTAGE] DECIMAL (16, 2) NULL,
    [NON_IC_BEDS_OCCUPIED_COVID]        INT             NULL,
    [DATE_LAST_INSERTED]                DATETIME        DEFAULT (getdate()) NULL,
    [IC_INFLUX_COVID]                   INT             NULL,
    [NON_IC_INFLUX_COVID]               INT             NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_HOSPITAL_BED_OCCUPANCY_DATE_LAST_INSERTED_DATE_OF_REPORT_3]
    ON [VWSDEST].[HOSPITAL_BED_OCCUPANCY]([DATE_LAST_INSERTED] ASC, [DATE_OF_REPORT] ASC)
    INCLUDE([DATE_OF_REPORT_UNIX], [IC_BEDS_OCCUPIED_COVID]);


GO
CREATE NONCLUSTERED INDEX [IX_HOSPITAL_BED_OCCUPANCY_DATE_LAST_INSERTED_DATE_OF_REPORT_2]
    ON [VWSDEST].[HOSPITAL_BED_OCCUPANCY]([DATE_LAST_INSERTED] ASC, [DATE_OF_REPORT] ASC)
    INCLUDE([DATE_OF_REPORT_UNIX], [NON_IC_BEDS_OCCUPIED_COVID]);


GO
CREATE NONCLUSTERED INDEX [IX_HOSPITAL_BED_OCCUPANCY_DATE_LAST_INSERTED_DATE_OF_REPORT]
    ON [VWSDEST].[HOSPITAL_BED_OCCUPANCY]([DATE_LAST_INSERTED] ASC, [DATE_OF_REPORT] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_HOSPITAL_BED_OCCUPANCY_DATE_LAST_INSERTED]
    ON [VWSDEST].[HOSPITAL_BED_OCCUPANCY]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_OF_REPORT_UNIX], [IC_BEDS_OCCUPIED_COVID], [IC_BEDS_OCCUPIED_NON_COVID], [IC_BEDS_OCCUPIED_COVID_PERCENTAGE]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_HOSPITAL_BED_OCCUPANCY_DOR_DLI]
    ON [VWSDEST].[HOSPITAL_BED_OCCUPANCY]([DATE_OF_REPORT] ASC)
    INCLUDE([DATE_LAST_INSERTED]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_HOSPITAL_BED_OCCUPANCY_DOR_2]
    ON [VWSDEST].[HOSPITAL_BED_OCCUPANCY]([DATE_OF_REPORT] ASC)
    INCLUDE([DATE_OF_REPORT_UNIX], [IC_BEDS_OCCUPIED_COVID], [DATE_LAST_INSERTED]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_HOSPITAL_BED_OCCUPANCY_DOR]
    ON [VWSDEST].[HOSPITAL_BED_OCCUPANCY]([DATE_OF_REPORT] ASC)
    INCLUDE([DATE_OF_REPORT_UNIX], [NON_IC_BEDS_OCCUPIED_COVID], [DATE_LAST_INSERTED]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_HOSPITAL_BED_OCCUPANCY_DLI]
    ON [VWSDEST].[HOSPITAL_BED_OCCUPANCY]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_OF_REPORT_UNIX], [NON_IC_BEDS_OCCUPIED_COVID]);

