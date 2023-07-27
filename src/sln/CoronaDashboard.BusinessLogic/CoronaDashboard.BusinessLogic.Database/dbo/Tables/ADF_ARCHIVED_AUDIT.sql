CREATE TABLE [dbo].[ADF_ARCHIVED_AUDIT] (
    [Timestamp]             NVARCHAR (MAX) NULL,
    [Level]                 NVARCHAR (MAX) NULL,
    [OperationName]         NVARCHAR (MAX) NULL,
    [OperationItem]         NVARCHAR (MAX) NULL,
    [Message]               NVARCHAR (MAX) NULL,
    [RowsCopied]            NVARCHAR (MAX) NULL,
    [RowsRead]              NVARCHAR (MAX) NULL,
    [TableName]             NVARCHAR (MAX) NULL,
    [DateLastInserted]      NVARCHAR (MAX) NULL,
    [OperationItemFilePath] NVARCHAR (MAX) NULL,
    [TableSchema]           NVARCHAR (MAX) NULL,
    [DateOfReport]          NVARCHAR (MAX) NULL
);

