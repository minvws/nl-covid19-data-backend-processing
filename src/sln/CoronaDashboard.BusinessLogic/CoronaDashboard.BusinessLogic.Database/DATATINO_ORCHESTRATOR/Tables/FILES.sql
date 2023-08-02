﻿CREATE TABLE [DATATINO_ORCHESTRATOR].[FILES] (
    [ID]            BIGINT        DEFAULT (NEXT VALUE FOR [DATATINO_ORCHESTRATOR].[SEQ_FILES]) NOT NULL,
    [FILE_NAME]     VARCHAR (MAX) NOT NULL,
    [LOCATION]      VARCHAR (MAX) NOT NULL,
    [DATE_INSERTED] DATETIME      DEFAULT (getdate()) NOT NULL
);

