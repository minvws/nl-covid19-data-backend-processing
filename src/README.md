# **HOW TO IMPLEMENT WORKFLOWS**

---

All code is written in *Jupyter Notebook* (with a optional `SQL kernel`), meaning that the files must be created and/or saved with the `.ipynb` file extension. The file itself will automatically be rendered into a *Jupyter Notebook* (within **[Visual Studio Code](https://code.visualstudio.com/Download)**), enabling documenting and writing code at the same time.

**[Azure DevOps CI/CD Pipelines](../.devops)** or **[GitHub Actions](../.github/workflows)** will be used to convert the modified `.ipynb` files into executable `.sql` scripts.

Generally the code, within *Jupyter Notebook*, is separated into multiple sections:

1. **[Tables](#**table-templates**)**
2. **[Views](#**view-templates**)**
3. **[Stored Procedures](#**stored-procedure-templates**)**
4. **[Datatino Configurations](#**datatino-configurations**)**

# **TABLE TEMPLATES**

---

### STAGING

---

```sql
-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
-- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- 1) CREATE SEQUENCE(S).....
DROP SEQUENCE IF EXISTS [dbo].[SEQ_VWSSTAGE_<table_name>]
CREATE SEQUENCE [dbo].[SEQ_VWSSTAGE_<table_name>]
    START WITH 1  
    INCREMENT BY 1;  
GO  

-- 2) CREATE TABLE(S).....
DROP TABLE IF EXISTS [VWSSTAGE].[<table_name>]

CREATE TABLE [VWSSTAGE].[<table_name>](
	[ID] [INT] PRIMARY KEY NONCLUSTERED NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_<table_name>]),
    [DATE_LAST_INSERTED] [DATETIME] NOT NULL DEFAULT GETDATE()
	-- ADD ADDITIONAL COLUMNS (ALL WITH TYPE NVARCHAR(256))
);
GO

-- 3) CREATE INDEX(ES).....
CREATE NONCLUSTERED INDEX [IX_STAGE_<table_name>] ON [VWSSTAGE].[<table_name>] (
	[DATE_LAST_INSERTED] ASC
) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
GO

```

#### *Details*:

1. `<table_name>` must be replaced with an unique name.
2. The `[DATE_LAST_INSERTED]` is used to filter the most recent inserted record(s) downstream the dataflows. 
3. :heavy_exclamation_mark: Do **not** insert or updated the `[DATE_LAST_INSERTED]` by external queries.
4. All column types, besides `[ID]` and `[DATE_LAST_INSERTED]`, must be set to `NVARCHAR(256)` to enable successful data ingestion.

### INTERMEDIATES

---

```sql
-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
-- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- 1) CREATE SEQUENCE(S).....
DROP SEQUENCE IF EXISTS [dbo].[SEQ_VWSINTER_<table_name>]
CREATE SEQUENCE [dbo].[SEQ_VWSINTER_<table_name>]
    START WITH 1  
    INCREMENT BY 1;  
GO  

-- 2) CREATE TABLE(S).....
DROP TABLE IF EXISTS [VWSINTER].[<table_name>]

CREATE TABLE [VWSINTER].[<table_name>](
	[ID] [INT] PRIMARY KEY NONCLUSTERED NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_<table_name>]),
    [DATE_LAST_INSERTED] [DATETIME] NOT NULL DEFAULT GETDATE()
	-- ADD ADDITIONAL COLUMNS (WITH TO CORRECT TYPE E.G. DATE, NVARCHAR(...), INT, ETC.)
);
GO

-- 3) CREATE INDEX(ES).....
CREATE NONCLUSTERED INDEX [IX_INTER_<table_name>] ON [VWSINTER].[<table_name>] (
	[DATE_LAST_INSERTED] ASC
) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
GO
```

#### *Details*:

1. `<table_name>` must be replaced with an unique name.
2. The `[DATE_LAST_INSERTED]` is used to filter the most recent inserted record(s) downstream the dataflows. 
3. :heavy_exclamation_mark: Do **not** insert or updated the `[DATE_LAST_INSERTED]` by external queries.
4. Cast all column types to the correct SQL datatypes (e.g. `DATE`, `NVARCHAR(...)`, `INT`).

### DESTINATIONS

---

```sql

-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
-- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- 1) CREATE SEQUENCE(S).....
DROP SEQUENCE IF EXISTS [dbo].[SEQ_VWSDEST_<table_name>]
CREATE SEQUENCE [dbo].[SEQ_VWSDEST_<table_name>]
    START WITH 1  
    INCREMENT BY 1;  
GO  

-- 2) CREATE TABLE(S).....
DROP TABLE IF EXISTS [VWSDEST].[<table_name>]

CREATE TABLE [VWSDEST].[<table_name>](
	[ID] [INT] PRIMARY KEY NONCLUSTERED NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_<table_name>]),
    [DATE_LAST_INSERTED] [DATETIME] NOT NULL DEFAULT GETDATE()
	-- ADD ADDITIONAL COLUMNS (WITH TO CORRECT TYPE E.G. DATE, NVARCHAR(...), INT, ETC.)
);
GO

-- 3) CREATE INDEX(ES).....
CREATE NONCLUSTERED INDEX [IX_DEST_<table_name>] ON [VWSDEST].[<table_name>] (
	[DATE_LAST_INSERTED] ASC
) WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY];
GO
```

#### *Details*:

1. `<table_name>` must be replaced with an unique name.
2. The `[DATE_LAST_INSERTED]` is used to filter the most recent inserted record(s) downstream the dataflows. 
3. :heavy_exclamation_mark: Do **not** insert or updated the `[DATE_LAST_INSERTED]` by external queries.
4. Cast all column types to the correct SQL datatypes (e.g. `DATE`, `NVARCHAR(...)`, `INT`).

# **VIEW TEMPLATES**

---

```sql
-- COPYRIGHT (C) 2021 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
-- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.

-- 1) CREATE VIEW(S).....
CREATE OR ALTER  VIEW [VWSDEST].[V_<table_name>]
AS
    SELECT
        -- SELECT COLUMNS,
        [DATE_OF_INSERTION_UNIX] = [dbo].[CONVERT_DATETIME_TO_UNIX][DATE_LAST_INSERTED]) 
    FROM [VWSDEST].[<table_name>]
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[<table_name>])
GO
```

#### *Details*:

1. `<table_name>` must be replaced with an unique name.
2. All DATE and DATETIME column types must be converted into UNIX with SQL functions such as `[dbo].[CONVERT_DATETIME_TO_UNIX](...)`.
    - After conversion add suffix `_unix` or `_UNIX` to the column name(s) (e.g. `[COLUMN_NAME]` to `[COLUMN_NAME_UNIX]` )
3. :heavy_exclamation_mark: `[DATE_OF_INSERTION_UNIX]` must always be included in the views.
4. Set all column names to uppercase (e.g. `[column_name]` to `[COLUMN_NAME]`).

# **STORED PROCEDURE TEMPLATES**

---

### STAGING &rarr; INTERMEDIATE MAPPING

---

```sql
-- COPYRIGHT (C) 2021 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
-- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.

-- 1) CREATE STORE PROCEDURE(S).....
CREATE OR ALTER PROCEDURE [dbo].[SP_<table_name>_STAGE_TO_INTER]
AS
BEGIN
    INSERT INTO [VWSINTER].[<table_name>]
    (
        -- ADD COLUMNS TO BE POPULATED 
    )
    SELECT
        -- SELECT COLUMNS TO BE INSERTED INTO THE TABLE AND ADDITIONAL FUNCTIONALITY. (CAST TO THE CORRECT DATATYPE, E.G. CAST([STAGE-FIELD] AS DATATYPE))
    FROM 
        [VWSSTAGE].[<table_name>]
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].[<table_name>])
END;
GO
```

#### *Details*:

1. `<table_name>` must be replaced with an unique name.
2. :heavy_exclamation_mark: Do **not** insert or updated the value regarding `[DATE_LAST_INSERTED]` and `[ID]` within the target table(s).

### INTERMEDIATE &rarr; DESTINATION MAPPING

---

```sql
-- COPYRIGHT (C) 2021 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
-- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATION FOR MORE INFORMATION.

-- 1) CREATE STORE PROCEDURE(S).....
CREATE OR ALTER PROCEDURE [dbo].[SP_<table_name>_INTER_TO_DEST]
AS
BEGIN
    INSERT INTO [VWSDEST].[<table_name>]
    (
        -- ADD COLUMNS TO BE POPULATED
    )
    SELECT
        -- SELECT COLUMNS TO BE INSERTED INTO THE TABLE AND ADDITIONAL FUNCTIONALITY.
    FROM 
        [VWSINTER].[<table_name>]
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[<table_name>])
END;
GO
```

#### *Details*:

1. `<table_name>` must be replaced with an unique name.
2. :heavy_exclamation_mark: Do **not** insert or updated the value regarding `[DATE_LAST_INSERTED]` and `[ID]` within the target table(s).

# **DATATINO CONFIGURATIONS**

---

### WORKFLOWS

---

```sql
-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN   VOLKSGEZONDHEID, WELZIJN EN SPORT.
-- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.

DECLARE @workflow_name NVARCHAR(50) = '<unique_name>',
        @workflow_id INT,        
        @workflow_description VARCHAR(256)

SELECT TOP(1)
    @workflow_id = workflows.[ID]
FROM [DATATINO_ORCHESTRATOR_1].[WORKFLOWS] workflows
INNER JOIN [DATATINO_ORCHESTRATOR_1].[V_WORKFLOWS] v_workflows ON v_workflows.[DATAFLOW_ID] = workflows.[DATAFLOW_ID] AND v_workflows.[ID] = workflows.[ID]
WHERE v_workflows.[NAME] = @workflow_name

SET @workflow_description = CONCATE('WORKFLOW: ', @workflow_name)

-- 1) UPSERT WORKFLOW(S).....
EXECUTE [DATATINO_ORCHESTRATOR_1].[UPSERT_WORKFLOW]
    @id = @workflow_id, 
    @workflow_name = @workflow_name,
    @description = @workflow_description,
    @schedule = '<cron_expression>', -- SEE https://crontab.cronhub.io/ FOR MORE INFORMATION.
    @active = 1 /*
        1) 0 = inactive,
        2) 1 = active
    */

-- 2) UPSERT SOURCE(S).....
EXECUTE [DATATINO_ORCHESTRATOR_1].[UPSERT_SOURCE] 
    @id = null,
    @source_name = '<unique_source_name>',
    @description = '<source_description>',
    @source = '<source_location>', /* 
        1) URL, 
        2) datafiles/<client>/<filename>.<file_extension> (see BlobStorage for clients)
        3) A storeprocedure (i.e. [dbo].[storeprocedure_name]) 
    */
    @source_columns = '<exact_column_names>', /* 
        1) column1|column2|...|etc. (case sensitive)
        2) null (if @source is a Storeprocedure) 
    */
    @target_columns = '<exact_target_names>', /*
        1) target1|target2|...|etc. (case sensitive)
        2) null (if @source is a Storeprocedure) 
    */
    @target_name = '<target_name>', /*
        1) A table (i.g. [schema].[table_name])
        2) null (if @source is a Storeprocedure)
    */
    @source_type = '<source_type>', /* 
        1) CsvFile  (for CSV files)
        2) JsonFile (for JSON files)
        3) StoredProcedure
        4) HTTP_POST
        5) RestrictedApi (to restrict the ingest records' amount)
    */
    @location_type = '<location_type>', /* 
        1) N/A (if using a storeprocedure)
        2) Web (Source file that can be found via a URL in the source)
        3) AzureBlob (Source file that can be found in an Azure Storage Account)
    */
    @delimiter_type = '<delimiter_type>', /* 
        1) N/A (if using other source types than CsvFile)
        2) Space (" ")
        3) Colon (",")
        4) SemiColon (";")
        5) Pipe ("|")
    */
    @security_profile= 'RIVM' /* 
        1) NA 
        2) NETWORK_CREDENTIAL (authenication by using <USERNAME>|<PASSWORD>)
        3) AZURE_BLOB (authentication by using a AzureBlob connection string)
        4) SQL_SERVER (authentication by using a Database connection string: Server=tcp:<SERVER_NAME>,<PORT>;Initial Catalog=<DATABASE_NAME>;User ID=<USER_NAME;Password=<PASSWORD>;)
        5) BEARER (authentication by using a Bearer token: Bearer <TOKEN>)
    */

-- 3) UPSERT PROCESS(ES).....
EXECUTE [DATATINO_ORCHESTRATOR_1].[UPSERT_PROCESS] 
    @id = null, 
    @process_name = '<unique_process_name>',
    @description = '<process_description>',
    @source_name = '<source_name>', -- see 2) UPSERT SOURCE(S).....
    @schedule = '<cron_expression>', -- see https://crontab.cronhub.io/ for more information.
    @workflow_name = @workflow_name,
    @active = 1 /*
        1) 0 = inactive,
        2) 1 = active
    */
    
-- 4) UPSERT DEPENDENC(Y)(IES).....
EXECUTE [DATATINO_ORCHESTRATOR_1].[UPSERT_DEPENDENCY]
    @id = null,
    @dataflow_name = '<process_name_to_trigger>', /*
        The process (a.k.a. dataflow name) that will be trigger after the '@dependency_name' is successfully finished.
    */
    @dataflowtype_id = 2, /*
        1) 1 = Workflow (to trigger another workflow)
        2) 2 = Process (to trigger another process)
    */
    @dependency_name = '<process_name_to_finish>', /*
        The process (a.k.a. dependency name) that MUST be finished before the '@dataflow_name' can be triggered.
    */
    @dependencytype_id = 2, /*
        1) 1 = Workflow
        2) 2 = Process
    */
    @workflow_name = @workflow_name,
    @name = '<unique_dependency_name',
    @description = '<dependency_description>',
    @active = 1 /*
        1) 0 = inactive,
        2) 1 = active
    */
```

### PROTOS

---

```sql
-- COPYRIGHT (C) 2020 DE STAAT DER NEDERLANDEN, MINISTERIE VAN   VOLKSGEZONDHEID, WELZIJN EN SPORT.
-- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.

-- 1) DETERMINE VIEW ID & CONFIGURATION ID
DECLARE @config_id INT, 
        @view_id INT,
        @view_name VARCHAR(256) = '<schema>.<view_name>', -- e.g. [schema].[view_name]
        @item_name VARCHAR(256) = '<unique_json_object_name>',
        @view_description VARCHAR(256),
        @config_description VARCHAR(256),
        @proto_name VARCHAR(50) = '<proto_name>' /*
        Descripts in which JSON message the output, of the configuration, will be inserted.    
    */

SET @view_description = CONCAT('VIEW: ', @view_name)
SET @config_description = CONCAT('VIEW CONFIGURATION: ', @view_name)

SELECT TOP(1)
    @config_id = configs.[ID],
    @view_id = views.[ID]
FROM [DATATINO_PROTO_1].[CONFIGURATIONS] configs
INNER JOIN [DATATINO_PROTO_1].[VIEWS] views ON views.[ID] = configs.[VIEW_ID] AND views.[NAME] = @view_name
INNER JOIN [DATATINO_PROTO_1].[PROTOS] protos ON protos.[ID] = configs.[PROTO_ID] AND protos.[NAME] = @proto_name
WHERE configs.[NAME] = @item_name

-- 2) UPSERT PROTO VIEW(S).....
EXECUTE [DATATINO_PROTO_1].[UPSERT_VIEW]
    @id = @view_id,
    @view_name = @view_name,
    @description = @view_description,
    @last_update_name = '<unique_column_view>', /* 
        The field within the View that will be used to uniquely group the records to one or multiple records.
    */
    @constraint_key_name = null,
    @constraint_value = null,
    @grouped_key_name = null,
    @grouped_last_update_name = null

-- 3) UPSERT PROTO CONFIGURATION(S).....
EXECUTE [DATATINO_PROTO_1].[UPSERT_CONFIGURATION]
    @id = @config_id,
    @proto_name = @proto_name,
    @description =  @config_description,
    @view_name = @view_name,
    @item_name = @item_name,
    @constrained = '0',
    @grouped = '0',
    @columns = '*', /*
        Descripts which column will be mapped to a JSON object.
        1) * = all columns will be mapped
        2) column1|column2|...|etc.
    */
    @mapping = '=LOWER()', -- Functionality to apply to the column names for the JSON output.
    @layout_type_id = '1', /*
        1) 1 = LASTVALUE (Publishes the values, including an object representing the last value, based on the stated date key)
        2) 2 = VALUES (Publishes only the values)
        3) 3 = LASTVALUEDIRECT (Publishes  an object representing the last value directly attached to the key)
        4) 4 = VALUESDIRECT (Publishes the values, directly attached to the key)
        5) 5 = SINGLEVALUE (Publishes the first available record returned from the data source)
        6) 6 = SINGLEVALUE (Publishes the first available record returned from the data source, directly attached to the key)
    */
    @active = '1' /*
        1) 0 = inactive,
```

#### *Details*:

1. The `UPSERT_<TYPE>` functionality is only applicaple when the `@id` is **not** equal to `null`.
2. Codespace: [link](https://kpmg-nl@dev.azure.com/kpmg-nl/VWS-covid19-migration-project/_git/Datatino)