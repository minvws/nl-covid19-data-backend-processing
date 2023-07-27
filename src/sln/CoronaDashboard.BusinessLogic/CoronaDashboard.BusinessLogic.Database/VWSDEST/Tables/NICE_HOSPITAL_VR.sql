﻿CREATE TABLE [VWSDEST].[NICE_HOSPITAL_VR] (
    [ID]                         INT             DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_NICE_HOSPITAL_VR]) NOT NULL,
    [DATE_OF_STATISTICS]         DATETIME        NULL,
    [VR_CODE]                    VARCHAR (100)   NULL,
    [VR_NAME]                    VARCHAR (100)   NULL,
    [REPORTED]                   INT             NULL,
    [HOSPITALIZED]               INT             NULL,
    [HOSPITALIZED_3D_AVG]        DECIMAL (16, 2) NULL,
    [REPORTED_3D_AVG]            DECIMAL (16, 2) NULL,
    [HOSPITALIZED_CUMULATIVE]    INT             NULL,
    [REPORTED_CUMULATIVE]        INT             NULL,
    [DATE_LAST_INSERTED]         DATETIME        DEFAULT (getdate()) NULL,
    [REPORTED_PER_MIL_LAST_WEEK] INT             NULL,
    [WEEK_START]                 DATETIME        NULL,
    [HOSPITALIZED_7D_AVG]        DECIMAL (16, 2) NULL,
    [WEEK_START_LAG]             DATETIME        NULL,
    [HOSPITALIZED_7D_AVG_LAG]    DECIMAL (16, 2) NULL,
    [REPORTED_7D_AVG]            DECIMAL (16, 2) NULL,
    [REPORTED_7D_AVG_LAG]        DECIMAL (16, 2) NULL,
    [HOSPITALIZED_7D_AVG_CUTOFF] DECIMAL (16, 2) NULL,
    [HOSPITALIZED_PER_100000]    DECIMAL (16, 2) NULL
);


GO
CREATE CLUSTERED INDEX [IX_VWSDEST_NICE_HOSPITAL_VR_IC]
    ON [VWSDEST].[NICE_HOSPITAL_VR]([DATE_LAST_INSERTED] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_NICE_HOSPITAL_VR_DEST]
    ON [VWSDEST].[NICE_HOSPITAL_VR]([DATE_OF_STATISTICS] ASC, [DATE_LAST_INSERTED] ASC, [VR_CODE] ASC)
    INCLUDE([HOSPITALIZED], [HOSPITALIZED_3D_AVG], [HOSPITALIZED_CUMULATIVE]);


GO
CREATE NONCLUSTERED INDEX [IX_NICE_HOSPITAL_VR_DATE_LAST_INSERTED]
    ON [VWSDEST].[NICE_HOSPITAL_VR]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_OF_STATISTICS], [VR_CODE], [REPORTED]);


GO
CREATE NONCLUSTERED INDEX [IX_NICE_HOSPITAL_NL_DEST]
    ON [VWSDEST].[NICE_HOSPITAL_VR]([DATE_OF_STATISTICS] ASC, [DATE_LAST_INSERTED] ASC)
    INCLUDE([HOSPITALIZED], [HOSPITALIZED_3D_AVG]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_NICE_HOSPITAL_VR_DLI_DS]
    ON [VWSDEST].[NICE_HOSPITAL_VR]([DATE_LAST_INSERTED] ASC, [DATE_OF_STATISTICS] ASC)
    INCLUDE([VR_CODE], [HOSPITALIZED_CUMULATIVE]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_NICE_HOSPITAL_VR_DLI]
    ON [VWSDEST].[NICE_HOSPITAL_VR]([DATE_LAST_INSERTED] ASC)
    INCLUDE([DATE_OF_STATISTICS], [VR_CODE], [HOSPITALIZED], [HOSPITALIZED_3D_AVG], [HOSPITALIZED_CUMULATIVE]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_NICE_HOSPITAL_VR_AVG]
    ON [VWSDEST].[NICE_HOSPITAL_VR]([DATE_LAST_INSERTED] ASC, [DATE_OF_STATISTICS] ASC)
    INCLUDE([VR_CODE], [HOSPITALIZED_3D_AVG]);


GO
CREATE NONCLUSTERED INDEX [IX_DEST_NICE_HOSPITAL_VR]
    ON [VWSDEST].[NICE_HOSPITAL_VR]([DATE_LAST_INSERTED] ASC, [DATE_OF_STATISTICS] ASC)
    INCLUDE([VR_CODE]);

