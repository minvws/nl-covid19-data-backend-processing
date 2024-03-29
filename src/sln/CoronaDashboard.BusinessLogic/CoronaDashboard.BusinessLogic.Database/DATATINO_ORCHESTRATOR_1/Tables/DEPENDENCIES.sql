﻿CREATE TABLE [DATATINO_ORCHESTRATOR_1].[DEPENDENCIES] (
    [ID]                          BIGINT         IDENTITY (1, 1) NOT NULL,
    [DATAFLOW_ID]                 BIGINT         NOT NULL,
    [DATAFLOW_TYPE_ID]            BIGINT         NOT NULL,
    [DEPENDENCY_ID]               BIGINT         NOT NULL,
    [DATAFLOW_TYPE_ID_DEPENDENCY] BIGINT         NOT NULL,
    [WORKFLOW_ID]                 BIGINT         NOT NULL,
    [ACTIVE]                      INT            NOT NULL,
    [NAME]                        NVARCHAR (200) NOT NULL,
    [DESCRIPTION]                 NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_DEPENDENCIES] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_DEPENDENCY_DATAFLOW] FOREIGN KEY ([DATAFLOW_ID], [DATAFLOW_TYPE_ID]) REFERENCES [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] ([ID], [DATAFLOW_TYPE_ID]),
    CONSTRAINT [FK_DEPENDENCY_DATAFLOW_DEPENDENCY] FOREIGN KEY ([DEPENDENCY_ID], [DATAFLOW_TYPE_ID_DEPENDENCY]) REFERENCES [DATATINO_ORCHESTRATOR_1].[DATAFLOWS] ([ID], [DATAFLOW_TYPE_ID]),
    CONSTRAINT [FK_DEPENDENCY_DATAFLOW_TYPE] FOREIGN KEY ([DATAFLOW_TYPE_ID]) REFERENCES [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] ([ID]),
    CONSTRAINT [FK_DEPENDENCY_DATAFLOW_TYPE_DEPENDENCY] FOREIGN KEY ([DATAFLOW_TYPE_ID_DEPENDENCY]) REFERENCES [DATATINO_ORCHESTRATOR_1].[DATAFLOW_TYPES] ([ID]),
    CONSTRAINT [FK_DEPENDENCY_WORKFLOW] FOREIGN KEY ([WORKFLOW_ID]) REFERENCES [DATATINO_ORCHESTRATOR_1].[WORKFLOWS] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IX_DEPENDENCIES_WORKFLOW_ID]
    ON [DATATINO_ORCHESTRATOR_1].[DEPENDENCIES]([WORKFLOW_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DEPENDENCIES_DEPENDENCY_ID_DATAFLOW_TYPE_ID_DEPENDENCY]
    ON [DATATINO_ORCHESTRATOR_1].[DEPENDENCIES]([DEPENDENCY_ID] ASC, [DATAFLOW_TYPE_ID_DEPENDENCY] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DEPENDENCIES_DATAFLOW_TYPE_ID_DEPENDENCY]
    ON [DATATINO_ORCHESTRATOR_1].[DEPENDENCIES]([DATAFLOW_TYPE_ID_DEPENDENCY] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DEPENDENCIES_DATAFLOW_TYPE_ID]
    ON [DATATINO_ORCHESTRATOR_1].[DEPENDENCIES]([DATAFLOW_TYPE_ID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_DEPENDENCIES_DATAFLOW_ID_DEPENDENCY_ID]
    ON [DATATINO_ORCHESTRATOR_1].[DEPENDENCIES]([DATAFLOW_ID] ASC, [DEPENDENCY_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_DEPENDENCIES_DATAFLOW_ID_DATAFLOW_TYPE_ID]
    ON [DATATINO_ORCHESTRATOR_1].[DEPENDENCIES]([DATAFLOW_ID] ASC, [DATAFLOW_TYPE_ID] ASC);

