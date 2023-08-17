﻿CREATE TABLE [DATATINO_ORCHESTRATOR].[SECURITY_PROFILES] (
    [ID]     BIGINT        DEFAULT (NEXT VALUE FOR [DATATINO_ORCHESTRATOR].[SEQ_SECURITY_PROFILES]) NOT NULL,
    [VALUE]  VARCHAR (200) NOT NULL,
    [SPT_ID] BIGINT        NOT NULL,
    [ACTIVE] INT           NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [CHK_ACTIVE_SECURITY_PROFILE] CHECK ([ACTIVE]=(1) OR [ACTIVE]=(0)),
    CONSTRAINT [FK_SECURITY_PROFILE_TYPE] FOREIGN KEY ([SPT_ID]) REFERENCES [DATATINO_ORCHESTRATOR].[SECURITY_PROFILE_TYPES] ([ID]),
    CONSTRAINT [UQ_VALUE_SPT] UNIQUE NONCLUSTERED ([VALUE] ASC, [SPT_ID] ASC)
);

