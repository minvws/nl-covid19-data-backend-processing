﻿CREATE TABLE [DATATINO_ORCHESTRATOR].[DEPENDENCIES] (
    [ID]          BIGINT DEFAULT (NEXT VALUE FOR [DATATINO_ORCHESTRATOR].[SEQ_DEPENDENCIES]) NOT NULL,
    [PROCESS_ID]  BIGINT NOT NULL,
    [DEPENDENCY]  BIGINT NOT NULL,
    [WORKFLOW_ID] BIGINT NOT NULL,
    [ACTIVE]      INT    DEFAULT ((1)) NOT NULL,
    CONSTRAINT [CHK_ACTIVE_DEPENDENCY] CHECK ([ACTIVE]=(1) OR [ACTIVE]=(0)),
    CONSTRAINT [FK_DEPENDENCY_DEPENDENCY] FOREIGN KEY ([DEPENDENCY]) REFERENCES [DATATINO_ORCHESTRATOR].[PROCESSES] ([ID]),
    CONSTRAINT [FK_PROCESS_IPRD_DEPENDENCY] FOREIGN KEY ([PROCESS_ID]) REFERENCES [DATATINO_ORCHESTRATOR].[PROCESSES] ([ID]),
    CONSTRAINT [FK_WORKFLOW_ID_DEPENDENCY] FOREIGN KEY ([WORKFLOW_ID]) REFERENCES [DATATINO_ORCHESTRATOR].[WORKFLOWS] ([ID]),
    CONSTRAINT [UQ_PROCESS_DEPENDENCY] UNIQUE NONCLUSTERED ([PROCESS_ID] ASC, [DEPENDENCY] ASC)
);

