CREATE TABLE [DATATINO_ORCHESTRATOR].[flyway_schema_history] (
    [installed_rank] INT             NOT NULL,
    [version]        NVARCHAR (50)   NULL,
    [description]    NVARCHAR (200)  NULL,
    [type]           NVARCHAR (20)   NOT NULL,
    [script]         NVARCHAR (1000) NOT NULL,
    [checksum]       INT             NULL,
    [installed_by]   NVARCHAR (100)  NOT NULL,
    [installed_on]   DATETIME        DEFAULT (getdate()) NOT NULL,
    [execution_time] INT             NOT NULL,
    [success]        BIT             NOT NULL,
    CONSTRAINT [flyway_schema_history_pk] PRIMARY KEY CLUSTERED ([installed_rank] ASC)
);


GO
CREATE NONCLUSTERED INDEX [flyway_schema_history_s_idx]
    ON [DATATINO_ORCHESTRATOR].[flyway_schema_history]([success] ASC);

