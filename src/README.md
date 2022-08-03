# **HOW TO IMPLEMENT WORKFLOWS**

---

All code is written in *Jupyter Notebook* (with a optional `SQL kernel`), meaning that the files must be created and/or saved with the `.ipynb` file extension. The document itself will automatically be rendered into a *Jupyter Notebook* (within **[Visual Studio Code](https://code.visualstudio.com/Download)**), enabling documenting and writing code at the same time.

**[Azure DevOps CI/CD Pipelines](../.devops)** will convert the modified `.ipynb` files into executable `.sql` scripts.

It's recommended to create novel *Jupyter Notebook* using the **[ipynb-generator.ps1](./DataFactory/ipynb-generator.ps1)**, which will automatically generate a standardized *Notebook* structure, a naming convention and SQL snippets to increase development velocity.

```powershell
. "./src/DataFactory/ipynb-generator.ps1" `
    # The entity that provides the source data (e.g., RIVM, CBS, Nivel, LCPS, etc). When the Azure Blob Storage is the main source, use VWS as value.
    -InputEntity "<RIVM|CBS|Nivel|LCPS|VWS>" `
    # Type of the dataset and their purpose, such as Protocols, Statics or Reports to devide it by indicator type (or usage).
    -IPynbType "<Protocols|Statics|Reports>" `
    # Meaningfull and unique name - PascalCase - of the Protocols, Statics or Reports workflow. A `pl_Process` prefix will be appended to the Notebooks to follow the naming conventions of `Azure Data Factory` in regards of the Pipelines.
    -IPynbName "<process-name>" `
    # Indicates how many JSON-objects will be create based on the datasets. 
    # Depending on the requirements, multiple JSON outputs can be generated from a singular source document, for example, RIVM, CBS and/or Nivel.
    -OutputLayers @(
        @{
            Name="<layer-name>"; # Meaningfull and unique name of the type (or usage) of the output dataset..
            ProtoName="<NL|VR_COLLECTION|GM_COLLECTION|GM|VR>"; <# 
            The scope in which the JSON-object will be used within the Corona Dashboard.
                1. NL = National
                2. VR = Safety Regions
                3. GM = Municipalities
                4. VR_COLLECTION = Safety Region Collection
                5. GM COLLECTION = Municipality Collection. 
            #>
            ItemName="<json-object-name>"; # Name of the JSON-object
            Columns="<*|COLUMNS>"; # Colomn(s) to be included within the JSON-object; a wildcard (*) means all columns will be included.
            LayoutTypeId="<1|2|3|4|5|6>"; <# 
            Layout of the JSON-object
                1) 1 = LASTVALUE (Publishes the values, including an object representing the last value, based on the stated date key)
                2) 2 = VALUES (Publishes only the values)
                3) 3 = LASTVALUEDIRECT (Publishes an object representing the last value directly attached to the key)
                4) 4 = VALUESDIRECT (Publishes the values, directly attached to the key)
                5) 5 = SINGLEVALUE (Publishes the first available record returned from the data source)
                6) 6 = SINGLEVALUE (Publishes the first available record returned from the data source, directly attached to the key)            
            #>
            LastUpdateName="<COLUMN_NAME>"; # Column to indictate the latest dataset from a collection.
            ConstraintValue="<COLUMN_VALUE>"; # (Optional) Column value to enable grouping of the VRXX and GMXX scoped output layers. Default: NULL
            ConstraintKeyName="<COLUMN_NAME>"; # (Optional) Column name which is used to find the 'ContrainedValue'. Default: NULL
            GroupedKeyName="<COLUMN_NAME>"; # (Optional) Enables the grouping of multiple datasets by the specified column name. The column name will be used in a higher level of the JSON-object compaired with the datasets (in arrays). Default: NULL
            GroupedLastUpdateName="<COLUMN_NAME>"; # (Optional) Column to indictate the latest dataset from a collection when it's grouped. Default: NULL
        }
        # More Outputs...
    )
```

Additionally, a disclaimer will also be added at the top of the *Notebook* after creation.

```sql
-- COPYRIGHT (C) 2022 DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.
-- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.
```

> Example

```powershell
. "./src/DataFactory/ipynb-generator.ps1" `
    -InputEntity "LCPS" `
    -IPynbType "Protocols" `
    -IPynbName "ExamplePynb" `
    -OutputLayers @( 
        @{
            Name="output layer example";
            ProtoName="VR";
            ItemName="example";
            Columns="*";
            LayoutTypeId="1";
            LastUpdateName="COLUMN_NAME";
        }
        # Add more outputs (if required)
    )
```

When running the generator, the sections that are created within *Notebook* are as followed:

1. **[Flow Diagrams](#flow-diagrams)**
2. **[Dependencies](#dependencies)**
3. **[Input Layer](#input-layer)**
    - [ ] Tables
4. **[Intermediate Layer](#intermediate-layer)**
   - [ ] Tables
   - [ ] Stored Procedures
5. **[Output Layer](#output-layer)**
   - [ ] Tables
   - [ ] Stored Procedures
   - [ ] Views
   - [ ] Views | Configurations

**<font color="red">NOTE!</font>** Depending on the `IPynbType` and `OutputLayers` the list of sections **WILL** vary. Several `IPynbType` combinations with the # of `OutputLayers` might be **functionally** redundant, by which it's recommended to adjust the combination.

|IPynb Type|Output Layers|Sections|Why?|
|--|--|--|--|
|`Protocols`|`yes`|1. Flow Diagrams</br>2. Dependencies</br>3. Input Layers</br>4. Intermediate Layers</br>5. Ouput Layers|Create a workflow that will have one (or more) sources that will be transformed (or translated) into one (or more) `JSON-objects`, which are updated regularly.|
|`Protocols`|`no`|~~1. Flow Diagrams</br>2. Dependencies</br>3. Input Layers</br>4. Intermediate Layers~~|**<font color="red">NOTE!</font>** Use a `Static` type with no `Output Layers` instead.|
|`Statics`|`yes`|~~1. Flow Diagrams</br>2. Dependencies</br>3. Input Layers</br>4. Static Layers</br>5. Ouput Layers~~|**<font color="red">NOTE!</font>** Use a `Protocols` type with one (or more) `Output Layers` instead.
|`Statics`|`no`|1. Flow Diagrams</br>2. Dependencies</br>3. Input Layers</br>4. Static Layers|Create a workflow that will have one (or more) sources that will be transformed (or translated) into one (or more) `ready-to-use` stored datasets, which change irregularly.|
|`Reports`|`yes`|1. Flow Diagrams</br>2. Dependencies</br>3. Input Layers</br>4. Intermediate Layers</br>5. Output Layers|Create a workflow that will have one (or more) sources that will be transformed (or translated) into one (or more) ***VIEWS*** that can be used for `Power BI`.|
|`Reports`|`no`|~~1. Flow Diagrams</br>2. Dependencies</br>3. Input Layers</br>4. Intermediate Layers~~|**<font color="red">NOTE!</font>** Use a `Static` type with no `Output Layers` instead.

## **FLOW DIAGRAMS**

---

Within the `Flow Diagrams` section it's recommended to add a **[Mermaid](https://mermaid-js.github.io/mermaid/#/)** diagram of the workflow of the specific *Notebook* in the `ADD DIAGRAM HERE!` part. 

Following the example the `Flow Diagram` would look similar to this:

[![](https://mermaid.ink/img/pako:eNp1kE9PwzAMxb9K5FMnrZV67YELcKhUrWiVdmk4mMZdA01S5Q8wTfvupCtDYwifIr_nn59zhM4IggL60Xx0A1rPWLXlmsVy4WVvcRpYqafgWYUHsovS2KS6f2pWLE0Zh16OpFFR1rl3DrF3x5o2cR73Uu9Xz8sIafGH6skqEhI9_YKfCWWbyCvD_5g6-Jt05RlQ521iFm2cNUafqKbxmsRuUBx22-zVGc1hUeqcpdl8IRY9pm6SWsclwLLI322qPLkwf5CwBhVDoxTxT49zm4MfSBGHIj4F2rcZfoq-MIl42KOQ3liI_NHRGjB40xx0B4W3gS6mB4kxofp2nb4AO4CLxQ)](https://mermaid-js.github.io/mermaid-live-editor/edit#pako:eNp1kE9PwzAMxb9K5FMnrZV67YELcKhUrWiVdmk4mMZdA01S5Q8wTfvupCtDYwifIr_nn59zhM4IggL60Xx0A1rPWLXlmsVy4WVvcRpYqafgWYUHsovS2KS6f2pWLE0Zh16OpFFR1rl3DrF3x5o2cR73Uu9Xz8sIafGH6skqEhI9_YKfCWWbyCvD_5g6-Jt05RlQ521iFm2cNUafqKbxmsRuUBx22-zVGc1hUeqcpdl8IRY9pm6SWsclwLLI322qPLkwf5CwBhVDoxTxT49zm4MfSBGHIj4F2rcZfoq-MIl42KOQ3liI_NHRGjB40xx0B4W3gS6mB4kxofp2nb4AO4CLxQ)

Additionally, adding an documentation of each steps within diagram is highly recommend and should be added within `ADD REQUIRMENT STEP LIST HERE!`.

## **DEPENDENCIES**

---

Within the `Dependencies` section it's required to add all directly dependent *Notebooks* at the relative path from the root of the project. By default `Function.ipynb`, `Schemas.ipynb` and `Protos.ipynb` are included.

```json
{
    "depends-on": [
        "src/DataFactory/Utils/Functions.ipynb",
        "src/DataFactory/Utils/Schemas.ipynb",
        "src/DataFactory/Utils/Protos.ipynb"
        // Additional dependencies (!NOTE! DO NOT FORGET THE COMMA (i.e. ,))
    ]
}
```

### **TROUBLESHOOTING**

---

|Error|Description|Remedy|
|--|--|--|
|`Build pipeline or local build errors`|It's is possible that opening the *Notebooks* in **[Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver16)** can cause a loss in the terminal ` ``` ` of the `Markdown`. In return the **[Build Script](../.devops/scripts/build-script.ps1)** will skip the dependency-determination, resulting in a failure within the build pipeline.|Double check if the dependency section is properly formatted.|

## **INPUT LAYER**

---

The `Input Layer` section is used to describe the staging datasets that will be ingest as-is (`RAW`) from the various sources (e.g, RIVM, LCPS, etc.). In case of the example, the source is `LCPS` meaning that the datasets will be stored in a staging database table that in turn will be used for downstream processing.

### **TABLES**

---

The name of the *Notebook* (i.e., `ExamplePynb`) and the entity (i.e, `LCPS`) are concatenated to create a unique table name.

```sql
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- 1) CREATE TABLE(S).....
IF NOT EXISTS (SELECT * FROM [SYS].[TABLES] WHERE [OBJECT_ID] = OBJECT_ID('[VWSSTAGE].[LCPS_EXAMPLE_PYNB]'))
CREATE TABLE [VWSSTAGE].[LCPS_EXAMPLE_PYNB] (
	[ID] [BIGINT] IDENTITY(1,1),
	[DATE_LAST_INSERTED] [DATETIME] DEFAULT GETDATE(),
	-- ADD COLUMNS
);
GO
```

## **INTERMEDIATE LAYER**

---

The `Intermediate Layer` section is used to translate or perform transformations to the staging datasets to a `ready-to-use` state, with the correct data-types, data-values, etc. To achieve this, `Tables` and a `Stored Procedures` are created with their respective snippets. ***By default one `Table` and one `Stored Procedure` are created.***

### **TABLES**

---

```sql
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- 1) CREATE TABLE(S).....
IF NOT EXISTS (SELECT * FROM [SYS].[TABLES] WHERE [OBJECT_ID] = OBJECT_ID('[VWSINTER].[LCPS_EXAMPLE_PYNB]'))
CREATE TABLE [VWSINTER].[LCPS_EXAMPLE_PYNB] (
	[ID] [BIGINT] IDENTITY(1,1),
	[DATE_LAST_INSERTED] [DATETIME] DEFAULT GETDATE(),
	-- ADD COLUMNS
);
GO
```

### **STORED PROCEDURES**

---

When the *Notebook* is create the `Stored Procedures` will use the `IPynbEntity` and `IPynbName` to create a unique `Stored Procedure` name. Additionall, depending on the `IPynbType` a prefix will be added to the name such as `SP_INSERT_IL_` for `Intermediate Layer` Stored Procedures.

```sql
-- 1) CREATE STORED PROCEDURE(S): STAGING TO INTERMEDIATE.....
CREATE OR ALTER PROCEDURE [dbo].[SP_INSERT_IL_LCPS_EXAMPLE_PYNB]
AS
BEGIN
    INSERT INTO [VWSINTER].[LCPS_EXAMPLE_PYNB] (
        -- ADD COLUMN NAMES
    )
    SELECT
        -- SELECT COLUMNS 
    FROM
        [VWSSTAGE].[LCPS_EXAMPLE_PYNB]
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].[LCPS_EXAMPLE_PYNB])
END;
GO
```

- **<font color=teal>IL</font>**: Intermediate Layer
- **<font color=teal>OL</font>**: Output Layer
- **<font color=teal>SL</font>**: Static Layer

## **OUTPUT LAYER**

---

### **TABLES**

---

The name of the *Outpuy Layer* (i.e., `OUTPUT_LAYER_EXAMPLE`) and the scope (i.e, `VR`) are concatated to create a unique table name.

```sql
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- 1) CREATE TABLE(S).....
IF NOT EXISTS (SELECT * FROM [SYS].[TABLES] WHERE [OBJECT_ID] = OBJECT_ID('[VWSDEST].[LCPS_OUTPUT_LAYER_EXAMPLE_VR]'))
CREATE TABLE [VWSDEST].[LCPS_OUTPUT_LAYER_EXAMPLE_VR] (
	[ID] [BIGINT] PRIMARY KEY IDENTITY(1,1),
	[DATE_LAST_INSERTED] [DATETIME] DEFAULT GETDATE(),
	-- ADD COLUMNS
);
GO

-- 2) CREATE INDEX(S).....
DROP INDEX IF EXISTS [NCIX_DLI_LCPS_OUTPUT_LAYER_EXAMPLE_VR] 
	ON [VWSDEST].[LCPS_OUTPUT_LAYER_EXAMPLE_VR]
GO

CREATE NONCLUSTERED INDEX [NCIX_DLI_LCPS_OUTPUT_LAYER_EXAMPLE_VR]
    ON [VWSDEST].[LCPS_OUTPUT_LAYER_EXAMPLE_VR] (
		[DATE_LAST_INSERTED]
	)
GO
```

### **STORED PROCEDURES**

---

When the *Notebook* is create the `Stored Procedures` will use the `IPynbEntity` and `IPynbName` to create a unique `Stored Procedure` name. Additionall, depending on the `IPynbType` a prefix will be added to the name such as `SP_INSERT_OL_` for `Output Layer` Stored Procedures.

```sql
-- 1) CREATE STORED PROCEDURE(S): INTERMEDIATE TO DESTINATION.....
CREATE OR ALTER PROCEDURE [dbo].[SP_INSERT_OL_LCPS_OUTPUT_LAYER_EXAMPLE_VR]
AS
BEGIN
    INSERT INTO [VWSDEST].[LCPS_OUTPUT_LAYER_EXAMPLE_VR] (
        -- ADD COLUMN NAMES
    )
    SELECT
        -- SELECT COLUMNS 
    FROM
        [VWSINTER].[LCPS_EXAMPLE_PYNB]
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].[LCPS_EXAMPLE_PYNB])
END;
GO
```

- **<font color=teal>IL</font>**: Intermediate Layer
- **<font color=teal>OL</font>**: Output Layer
- **<font color=teal>SL</font>**: Static Layer

### **VIEWS**

---

```sql
-- 1) CREATE VIEW(S).....
CREATE OR ALTER VIEW [VWSDEST].[V_LCPS_OUTPUT_LAYER_EXAMPLE_VR] AS
WITH CTE AS (
    SELECT
        -- SELECT COLUMNS
    FROM [VWSDEST].[LCPS_OUTPUT_LAYER_EXAMPLE_VR] WITH(NOLOCK)
    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].[LCPS_OUTPUT_LAYER_EXAMPLE_VR] WITH(NOLOCK))
)
SELECT
    *
FROM CTE
GO
```

### **VIEWS | CONFIGURATION**

---

```sql
-- 1) SELECT PROTO(S).....
DECLARE @current_proto_name VARCHAR(50)

DECLARE @proto_name_table TABLE (
    [PROTO_NAME] VARCHAR(50)
);
INSERT INTO @proto_name_table 
SELECT Distinct [NAME]
    FROM [DATATINO_PROTO_1].[PROTOS]
    WHERE NAME NOT LIKE 'VR_COLLECTION' AND NAME LIKE 'VR%' 
ORDER BY NAME

DECLARE CUR CURSOR LOCAL FAST_FORWARD
FOR
SELECT [PROTO_NAME]
FROM @proto_name_table;

OPEN CUR;

FETCH NEXT FROM CUR
INTO @current_proto_name;

WHILE @@FETCH_STATUS = 0
BEGIN

    -- 2) SET ENVIRONMENTAL VARIABLES.....
    DECLARE @view_name VARCHAR(256) = 'VWSDEST.V_LCPS_OUTPUT_LAYER_EXAMPLE_VR',
        @view_description VARCHAR(256),
        @item_name VARCHAR(256) = 'example',
        @config_description VARCHAR(256),
        @constraint_value VARCHAR(50) = @current_proto_name,
        @constraint_key_name VARCHAR(50) = NULL,
        @grouped_key_name VARCHAR(50) = NULL,
        @grouped_last_update_name VARCHAR(50) = NULL,
        @proto_name VARCHAR(50) = @current_proto_name,
        @columns VARCHAR(256) = '*',
        @layout_type_id INT = 1,
        @last_update_name VARCHAR(50) = 'COLUMN_NAME',
        @is_active INT;

    SET @is_active = CASE LOWER('#{ Environment }#')
        WHEN 'production' THEN 1
        WHEN 'acceptance' THEN 1
        ELSE 1
    END;

    SET @view_description = CONCAT('VIEW: ', @view_name, ' FOR ', @item_name);
    SET @config_description = CONCAT('VIEW CONFIGURATION: ', @view_name, ' FOR ', @item_name);

    -- 3) DETERMINE VIEW ID & CONFIGURATION ID
    DECLARE @constrained INT,
            @grouped INT,
            @view_id BIGINT,
            @config_id BIGINT;

    SET @constrained = CASE 
        WHEN @constraint_key_name IS NULL THEN 0
        ELSE 1
    END;
    SET @grouped = CASE 
        WHEN @grouped_key_name IS NULL THEN 0
        ELSE 1
    END;

    DELETE FROM [DATATINO_PROTO_1].[CONFIGURATIONS]
    WHERE [ID] IN (
        SELECT
            configs.[ID]
        FROM [DATATINO_PROTO_1].[VIEWS] views
        INNER JOIN [DATATINO_PROTO_1].[CONFIGURATIONS] AS configs ON views.[ID] = configs.[VIEW_ID]
            AND configs.[NAME] = @item_name
        INNER JOIN [DATATINO_PROTO_1].[PROTOS] AS protos ON protos.[ID] = configs.[PROTO_ID]
            AND protos.[NAME] = @proto_name
    );

    SELECT 
        @view_id = [ID]
    FROM [DATATINO_PROTO_1].[VIEWS]
    WHERE ISNULL([CONSTRAINT_VALUE], 'X') = ISNULL(@constraint_value, 'X')
        AND ISNULL([CONSTRAINT_KEY_NAME], 'X') = ISNULL(@constraint_key_name, 'X')
        AND ISNULL([GROUPED_KEY_NAME], 'X') = ISNULL(@grouped_key_name, 'X')
        AND ISNULL([GROUPED_LAST_UPDATE_NAME], 'X') = ISNULL(@grouped_last_update_name, 'X')
        AND [NAME] = @view_name

    SELECT
        @config_id = configs.[ID]
    FROM [DATATINO_PROTO_1].[VIEWS] views
    INNER JOIN [DATATINO_PROTO_1].[CONFIGURATIONS] AS configs ON views.[ID] = configs.[VIEW_ID]
        AND configs.[NAME] = @item_name
        AND configs.[VIEW_ID] = @view_id
    INNER JOIN [DATATINO_PROTO_1].[PROTOS] AS protos ON protos.[ID] = configs.[PROTO_ID]
        AND protos.[NAME] = @proto_name
    WHERE views.[NAME] = @view_name;

    -- 4) UPSERT PROTO VIEW(S).....
    EXECUTE [DATATINO_PROTO_1].[UPSERT_VIEW]
        @id = @view_id,
        @view_name = @view_name,
        @description = @view_description,
        @last_update_name = @last_update_name,
        @constraint_key_name = @constraint_key_name,
        @constraint_value = @constraint_value,
        @grouped_key_name = @grouped_key_name,
        @grouped_last_update_name = @grouped_last_update_name;

    -- 5) UPSERT PROTO CONFIGURATION(S).....
    EXECUTE [DATATINO_PROTO_1].[UPSERT_CONFIGURATION]
        @id = @config_id,
        @proto_name = @proto_name,
        @description =  @config_description,
        @view_name = @view_name,
        @item_name = @item_name,
        @constrained = @constrained,
        @grouped = @grouped,
        @columns = @columns,
        @mapping = '=LOWER()',
        @layout_type_id = @layout_type_id,
        @active = @is_active,
        @constraint_key_name = @constraint_key_name,
        @constraint_value = @constraint_value,
        @grouped_key_name = @grouped_key_name,
        @grouped_last_update_name = @grouped_last_update_name;

    FETCH NEXT FROM CUR
    INTO @current_proto_name;    
END

CLOSE CUR;
DEALLOCATE CUR;
DELETE FROM @proto_name_table;
GO
```