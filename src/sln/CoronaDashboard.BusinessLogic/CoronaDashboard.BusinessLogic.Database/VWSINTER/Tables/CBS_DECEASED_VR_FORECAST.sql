﻿CREATE TABLE [VWSINTER].[CBS_DECEASED_VR_FORECAST] (
    [ID]                     INT           DEFAULT (NEXT VALUE FOR [DBO].[SEQ_VWSINTER_CBS_DECEASED_VR_FORECAST]) NOT NULL,
    [YEAR]                   INT           NULL,
    [WEEK]                   INT           NULL,
    [DECEASED_FORECAST]      INT           NULL,
    [DECEASED_FORECAST_LOW]  INT           NULL,
    [DECEASED_FORECAST_HIGH] INT           NULL,
    [VRNAME]                 VARCHAR (100) NULL,
    [VRCODE]                 VARCHAR (100) NULL,
    [DATE_LAST_INSERTED]     DATETIME      DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_VWS_VWSINTER_CBS_DECEASED_VR_FORECAST]
    ON [VWSINTER].[CBS_DECEASED_VR_FORECAST]([DATE_LAST_INSERTED] ASC)
    INCLUDE([YEAR], [WEEK], [DECEASED_FORECAST], [DECEASED_FORECAST_LOW], [DECEASED_FORECAST_HIGH], [VRNAME], [VRCODE]);

