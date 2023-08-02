﻿CREATE TABLE [DATATINO_PROTO_1].[CONFIGURATIONS] (
    [ID]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [PROTO_ID]       BIGINT         NOT NULL,
    [VIEW_ID]        BIGINT         NOT NULL,
    [CONSTRAINED]    INT            NOT NULL,
    [GROUPED]        INT            NOT NULL,
    [COLUMNS]        NVARCHAR (MAX) NOT NULL,
    [MAPPING]        NVARCHAR (MAX) NULL,
    [LAYOUT_TYPE_ID] BIGINT         NOT NULL,
    [MOCK_ID]        BIGINT         NULL,
    [ACTIVE]         INT            NOT NULL,
    [NAME]           NVARCHAR (200) NOT NULL,
    [DESCRIPTION]    NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_CONFIGURATIONS] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [FK_CONFIGURATION_LAYOUT_TYPE] FOREIGN KEY ([LAYOUT_TYPE_ID]) REFERENCES [DATATINO_PROTO_1].[LAYOUT_TYPES] ([ID]),
    CONSTRAINT [FK_CONFIGURATION_MOCK] FOREIGN KEY ([MOCK_ID]) REFERENCES [DATATINO_PROTO_1].[MOCKS] ([ID]),
    CONSTRAINT [FK_CONFIGURATION_PROTO] FOREIGN KEY ([PROTO_ID]) REFERENCES [DATATINO_PROTO_1].[PROTOS] ([ID]),
    CONSTRAINT [FK_CONFIGURATION_VIEW] FOREIGN KEY ([VIEW_ID]) REFERENCES [DATATINO_PROTO_1].[VIEWS] ([ID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CONFIGURATIONS_VIEW_ID]
    ON [DATATINO_PROTO_1].[CONFIGURATIONS]([VIEW_ID] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_CONFIGURATIONS_PROTO_ID_NAME]
    ON [DATATINO_PROTO_1].[CONFIGURATIONS]([PROTO_ID] ASC, [NAME] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CONFIGURATIONS_MOCK_ID]
    ON [DATATINO_PROTO_1].[CONFIGURATIONS]([MOCK_ID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CONFIGURATIONS_LAYOUT_TYPE_ID]
    ON [DATATINO_PROTO_1].[CONFIGURATIONS]([LAYOUT_TYPE_ID] ASC);

