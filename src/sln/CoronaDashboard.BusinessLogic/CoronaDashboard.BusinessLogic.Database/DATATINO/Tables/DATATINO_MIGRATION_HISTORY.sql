﻿CREATE TABLE [DATATINO].[DATATINO_MIGRATION_HISTORY] (
    [MigrationId]    NVARCHAR (150) NOT NULL,
    [ProductVersion] NVARCHAR (32)  NOT NULL,
    CONSTRAINT [PK_DATATINO_MIGRATION_HISTORY] PRIMARY KEY CLUSTERED ([MigrationId] ASC)
);

