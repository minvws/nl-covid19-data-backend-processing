param (
    [PSCustomObject[]] $OutputLayers = @{ 
        Name               = "<OutputLayerName>"; # Will be ignored by 1 OutputLayer
        Scope              = "<NL|VR_COLLECTION|GM_COLLECTION>"; 
        JsonKey            = "<JSON Key>"; 
        JsonProperties     = "<*|JSON Properties>"; 
        JsonLayout         = "<1|2|3|4>"; #<LASTVALUES|VALUES|etc.>
        JsonLastUpdateName = "<DATE_UNIX|DATE_END_UNIX>" 
    },
    [Parameter(Mandatory = $true)][String] $Entity = "<RIVM|CBS|LNAP|NIVEL>",
    [Parameter(Mandatory = $true)][String] $Service,
    [Parameter(Mandatory = $true)][String] $Type = "Protocols"
)

$ErrorActionPreference = "Stop"

$mainTableName = $($Entity + $($Service -creplace '([A-Z\W]|\d+)(?<![a-z])', '_$&' ).Trim()).ToUpper()

if ($OutputLayers.Count -gt 0 -and $Type -ne 'Statics') {
    foreach ($layer in $OutputLayers) {

        if ($layer.Name -eq "<OutputLayerName>") {
            Write-Error 'Failed to create Notebook....
Please use the following snippet and put it within the -OuputLayers parameter: 
@{ 
    Name = "<OutputLayerName>"; 
    Scope = "<NL|VR_COLLECTION|GM_COLLECTION>"; 
    JsonKey = "<JSON Key>"; 
    JsonProperties = "<*|JSON Properties>"; 
    JsonLayout = "<1|2|3|4>"; #<LASTVALUES|VALUES|etc.>
    JsonLastUpdateName = "<DATE_UNIX|DATE_END_UNIX>" 
}
For example: 
. "./.init-ipynb.ps1" -Service "ServiceName1" -Type "Protocols" -Entity "Entity1" -OutputLayers @{ 
    Name = "Name1"; 
    Scope = "nl"; 
    JsonKey = "json_key1"; 
    JsonProperties = "json_property1|json_property2"; 
    JsonLayout = "1"; #<LASTVALUES|VALUES|etc.>
    JsonLastUpdateName = "DATE_UNIX" 
}';
        }
    }
}

$outputFile = "src/DataFactory/$($Type)/pl_Process$($Service).ipynb";

# if (Test-Path $outputFile) {
#     Write-Error "Service with Type combination already created...
# Remove already existing Notebook: $($outputFile)
# and re-run the script...";
# }
# else {
if ($OutputLayers.Count -gt 1) {

    $_outputLayer = $OutputLayers | ForEach-Object {

        $layerName = $_.Name.Trim().ToUpper();
        $layerTableName = $($Entity + '_' + $layerName.Replace(" ", "_")).Trim().ToUpper();
        $layerScope = $_.Scope;
        $layerJsonKey = $_.JsonKey;
        $layerJsonProperties = $_.JsonProperties;
        $layerJsonLayout = $_.JsonLayout;
        $layerJsonLastUpdateName = $_.JsonLastUpdateName;

        return '{
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "## **<span style=''color:teal''>' + $layerName + '</span>**"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### **<span style=''color:cadetblue''>TABLES</span>**"
        ]
    },
    {
        "cell_type": "code",
        "execution_count": null,
        "metadata": {},
        "outputs": [],
        "source": [
            "SET ANSI_NULLS ON\n",
            "GO\n",
            "\n",
            "SET QUOTED_IDENTIFIER ON\n",
            "GO\n",
            "\n",
            "-- 1) CREATE TABLE(S).....\n",
            "IF NOT EXISTS (SELECT * FROM [SYS].[TABLES] WHERE [OBJECT_ID] = OBJECT_ID(''[VWSDEST].['+ $layerTableName + ']''))\n",
            "CREATE TABLE [VWSDEST].['+ $layerTableName + '] (\n",
            "\t[ID] [BIGINT] PRIMARY KEY IDENTITY(1,1),\n",
            "\t[DATE_LAST_INSERTED] [DATETIME] DEFAULT GETDATE(),\n",
            "\t-- ADD COLUMNS\n",
            ");\n",
            "GO\n",
            "\n",
            "-- 2) CREATE INDEX(S).....\n",
            "DROP INDEX IF EXISTS [NCIX_DLI_'+ $layerTableName + '] \n",
            "\tON [VWSDEST].['+ $layerTableName + ']\n",
            "GO\n",
            "\n",
            "CREATE NONCLUSTERED INDEX [NCIX_DLI_'+ $layerTableName + ']\n",
            "    ON [VWSDEST].['+ $layerTableName + '] (\n",
            "\t\t[DATE_LAST_INSERTED]\n",
            "\t)\n",
            "GO"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### **<span style=''color:cadetblue''>STORED PROCEDURES</span>**"
        ]
    },
    {
        "cell_type": "code",
        "execution_count": null,
        "metadata": {},
        "outputs": [],
        "source": [
            "-- 1) CREATE STORED PROCEDURE(S): INTERMEDIATE TO DESTINATION.....\n",
            "CREATE OR ALTER PROCEDURE [dbo].[SP_INSERT_OL_'+ $layerTableName + ']\n",
            "AS\n",
            "BEGIN\n",
            "    INSERT INTO [VWSDEST].['+ $layerTableName + '] (\n",
            "        -- ADD COLUMN NAMES\n",
            "    )\n",
            "    SELECT\n",
            "        -- SELECT COLUMNS \n",
            "    FROM\n",
            "        [VWSINTER].['+ $mainTableName + ']\n",
            "    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].['+ $mainTableName + '])\n",
            "END;\n",
            "GO"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### **<span style=''color:cadetblue''>VIEWS</span>**"
        ]
    },
    {
        "cell_type": "code",
        "execution_count": null,
        "metadata": {},
        "outputs": [],
        "source": [
            "-- 1) CREATE VIEW(S).....\n",
            "CREATE OR ALTER VIEW [VWSDEST].[V_'+ $layerTableName + '] AS\n",
            "WITH CTE AS (\n",
            "    SELECT\n",
            "        -- SELECT COLUMNS\n",
            "    FROM [VWSDEST].['+ $layerTableName + '] WITH(NOLOCK)\n",
            "    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].['+ $layerTableName + '] WITH(NOLOCK))\n",
            ")\n",
            "SELECT\n",
            "    *\n",
            "FROM CTE\n",
            "GO"
        ]
    },
    {
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            "### **<span style=''color:cadetblue''>VIEWS | CONFIGURATION</span>**"
        ]
    },
    {
        "cell_type": "code",
        "execution_count": null,
        "metadata": {},
        "outputs": [],
        "source": [
            "-- 1) SET ENVIRONMENTAL VARIABLES.....\n",
            "DECLARE @view_name VARCHAR(256) = ''VWSDEST.V_'+ $layerTableName + ''',\n",
            "        @view_description VARCHAR(256),\n",
            "        @item_name VARCHAR(256) = '''+ $layerJsonKey + ''',\n",
            "        @config_description VARCHAR(256),\n",
            "        @constraint_value VARCHAR(50) = NULL,\n",
            "        @constraint_key_name VARCHAR(50) = NULL,\n",
            "        @grouped_key_name VARCHAR(50) = NULL,\n",
            "        @grouped_last_update_name VARCHAR(50) = NULL,\n",
            "        @proto_name VARCHAR(50) = ''' + $layerScope.ToUpper() + ''',\n",
            "        @columns VARCHAR(256) = ''' + $layerJsonProperties + ''',\n",
            "        @layout_type_id INT = ' + $layerJsonLayout + ',\n",
            "        @last_update_name VARCHAR(50) = ''' + $layerJsonLastUpdateName + ''',\n",
            "        @is_active INT;\n",
            "        \n",
            "SET @is_active = CASE LOWER(''#{ Environment }#'')\n",
            "    WHEN ''production'' THEN 1\n",
            "    WHEN ''acceptance'' THEN 1\n",
            "    ELSE 1\n",
            "END;\n",
            "\n",
            "SET @view_description = CONCAT(''VIEW: '', @view_name, '' FOR '', @item_name);\n",
            "SET @config_description = CONCAT(''VIEW CONFIGURATION: '', @view_name, '' FOR '', @item_name);\n",
            "\n",
            "-- 2) DETERMINE VIEW ID & CONFIGURATION ID\n",
            "DECLARE @constrained INT,\n",
            "        @grouped INT,\n",
            "        @view_id BIGINT,\n",
            "        @config_id BIGINT;\n",
            "\n",
            "SET @constrained = CASE \n",
            "    WHEN @constraint_key_name IS NULL THEN 0\n",
            "    ELSE 1\n",
            "END;\n",
            "SET @grouped = CASE \n",
            "    WHEN @grouped_key_name IS NULL THEN 0\n",
            "    ELSE 1\n",
            "END;\n",
            "\n",
            "DELETE FROM [DATATINO_PROTO_1].[CONFIGURATIONS]\n",
            "WHERE [ID] IN (\n",
            "    SELECT\n",
            "        configs.[ID]\n",
            "    FROM [DATATINO_PROTO_1].[VIEWS] views\n",
            "    INNER JOIN [DATATINO_PROTO_1].[CONFIGURATIONS] AS configs ON views.[ID] = configs.[VIEW_ID]\n",
            "        AND configs.[NAME] = @item_name\n",
            "    INNER JOIN [DATATINO_PROTO_1].[PROTOS] AS protos ON protos.[ID] = configs.[PROTO_ID]\n",
            "        AND protos.[NAME] = @proto_name\n",
            ");\n",
            "\n",
            "SELECT \n",
            "    @view_id = [ID]\n",
            "FROM [DATATINO_PROTO_1].[VIEWS]\n",
            "WHERE ISNULL([CONSTRAINT_VALUE], ''X'') = ISNULL(@constraint_value, ''X'')\n",
            "    AND ISNULL([CONSTRAINT_KEY_NAME], ''X'') = ISNULL(@constraint_key_name, ''X'')\n",
            "    AND ISNULL([GROUPED_KEY_NAME], ''X'') = ISNULL(@grouped_key_name, ''X'')\n",
            "    AND ISNULL([GROUPED_LAST_UPDATE_NAME], ''X'') = ISNULL(@grouped_last_update_name, ''X'')\n",
            "    AND [NAME] = @view_name;\n",
            "\n",
            "SELECT\n",
            "    @config_id = configs.[ID]\n",
            "FROM [DATATINO_PROTO_1].[VIEWS] views\n",
            "INNER JOIN [DATATINO_PROTO_1].[CONFIGURATIONS] AS configs ON views.[ID] = configs.[VIEW_ID]\n",
            "    AND configs.[NAME] = @item_name\n",
            "    AND configs.[VIEW_ID] = @view_id\n",
            "INNER JOIN [DATATINO_PROTO_1].[PROTOS] AS protos ON protos.[ID] = configs.[PROTO_ID]\n",
            "    AND protos.[NAME] = @proto_name\n",
            "WHERE views.[NAME] = @view_name;\n",
            "\n",
            "-- 3) UPSERT PROTO VIEW(S).....\n",
            "EXECUTE [DATATINO_PROTO_1].[UPSERT_VIEW]\n",
            "    @id = @view_id,\n",
            "    @view_name = @view_name,\n",
            "    @description = @view_description,\n",
            "    @last_update_name = @last_update_name,\n",
            "    @constraint_key_name = @constraint_key_name,\n",
            "    @constraint_value = @constraint_value,\n",
            "    @grouped_key_name = @grouped_key_name,\n",
            "    @grouped_last_update_name = @grouped_last_update_name;\n",
            "\n",
            "-- 4) UPSERT PROTO CONFIGURATION(S).....\n",
            "EXECUTE [DATATINO_PROTO_1].[UPSERT_CONFIGURATION]\n",
            "    @id = @config_id,\n",
            "    @proto_name = @proto_name,\n",
            "    @description =  @config_description,\n",
            "    @view_name = @view_name,\n",
            "    @item_name = @item_name,\n",
            "    @constrained = @constrained,\n",
            "    @grouped = @grouped,\n",
            "    @columns = @columns,\n",
            "    @mapping = ''=LOWER()'',\n",
            "    @layout_type_id = @layout_type_id,\n",
            "    @active = @is_active,\n",
            "    @constraint_key_name = @constraint_key_name,\n",
            "    @constraint_value = @constraint_value,\n",
            "    @grouped_key_name = @grouped_key_name,\n",
            "    @grouped_last_update_name = @grouped_last_update_name;\n",
            "GO"
        ]
    }'
    }
}
else {
    $_outputLayer = $OutputLayers | ForEach-Object {

        $layerName = $mainTableName;
        $layerTableName = $layerName.Trim().ToUpper();
        $layerScope = $_.Scope;
        $layerJsonKey = $_.JsonKey;
        $layerJsonProperties = $_.JsonProperties;
        $layerJsonLayout = $_.JsonLayout;
        $layerJsonLastUpdateName = $_.JsonLastUpdateName;
            
        return '
        {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
                "## **<span style=''color:teal''>TABLES</span>**"
            ]
        },
        {
            "cell_type": "code",
            "execution_count": null,
            "metadata": {},
            "outputs": [],
            "source": [
                "SET ANSI_NULLS ON\n",
                "GO\n",
                "\n",
                "SET QUOTED_IDENTIFIER ON\n",
                "GO\n",
                "\n",
                "-- 1) CREATE TABLE(S).....\n",
                "IF NOT EXISTS (SELECT * FROM [SYS].[TABLES] WHERE [OBJECT_ID] = OBJECT_ID(''[VWSDEST].['+ $layerTableName + ']''))\n",
                "CREATE TABLE [VWSDEST].['+ $layerTableName + '] (\n",
                "\t[ID] [BIGINT] PRIMARY KEY IDENTITY(1,1),\n",
                "\t[DATE_LAST_INSERTED] [DATETIME] DEFAULT GETDATE(),\n",
                "\t-- ADD COLUMNS\n",
                ");\n",
                "GO\n",
                "\n",
                "-- 2) CREATE INDEX(S).....\n",
                "DROP INDEX IF EXISTS [NCIX_DLI_'+ $layerTableName + '] \n",
                "\tON [VWSDEST].['+ $layerTableName + ']\n",
                "GO\n",
                "\n",
                "CREATE NONCLUSTERED INDEX [NCIX_DLI_'+ $layerTableName + ']\n",
                "    ON [VWSDEST].['+ $layerTableName + '] (\n",
                "\t\t[DATE_LAST_INSERTED]\n",
                "\t)\n",
                "GO"
            ]
        },
        {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
                "## **<span style=''color:teal''>STORED PROCEDURES</span>**"
            ]
        },
        {
            "cell_type": "code",
            "execution_count": null,
            "metadata": {},
            "outputs": [],
            "source": [
                "-- 1) CREATE STORED PROCEDURE(S): INTERMEDIATE TO DESTINATION.....\n",
                "CREATE OR ALTER PROCEDURE [dbo].[SP_INSERT_OL_'+ $layerTableName + ']\n",
                "AS\n",
                "BEGIN\n",
                "    INSERT INTO [VWSDEST].['+ $layerTableName + '] (\n",
                "        -- ADD COLUMN NAMES\n",
                "    )\n",
                "    SELECT\n",
                "        -- SELECT COLUMNS \n",
                "    FROM\n",
                "        [VWSINTER].['+ $layerTableName + ']\n",
                "    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].['+ $layerTableName + '])\n",
                "END;\n",
                "GO"
            ]
        },
        {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
                "## **<span style=''color:teal''>VIEWS</span>**"
            ]
        },
        {
            "cell_type": "code",
            "execution_count": null,
            "metadata": {},
            "outputs": [],
            "source": [
                "-- 1) CREATE VIEW(S).....\n",
                "CREATE OR ALTER VIEW [VWSDEST].[V_'+ $layerTableName + '] AS\n",
                "WITH CTE AS (\n",
                "    SELECT\n",
                "        -- SELECT COLUMNS\n",
                "    FROM [VWSDEST].['+ $layerTableName + '] WITH(NOLOCK)\n",
                "    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].['+ $layerTableName + '] WITH(NOLOCK))\n",
                ")\n",
                "SELECT\n",
                "    *\n",
                "FROM CTE\n",
                "GO"
            ]
        },
        {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
                "### **<span style=''color:cadetblue''>VIEWS | CONFIGURATION</span>**"
            ]
        },
        {
            "cell_type": "code",
            "execution_count": null,
            "metadata": {},
            "outputs": [],
            "source": [
                "-- 1) SET ENVIRONMENTAL VARIABLES.....\n",
                "DECLARE @view_name VARCHAR(256) = ''VWSDEST.V_'+ $layerTableName + ''',\n",
                "        @view_description VARCHAR(256),\n",
                "        @item_name VARCHAR(256) = '''+ $layerJsonKey + ''',\n",
                "        @config_description VARCHAR(256),\n",
                "        @constraint_value VARCHAR(50) = NULL,\n",
                "        @constraint_key_name VARCHAR(50) = NULL,\n",
                "        @grouped_key_name VARCHAR(50) = NULL,\n",
                "        @grouped_last_update_name VARCHAR(50) = NULL,\n",
                "        @proto_name VARCHAR(50) = ''' + $layerScope.ToUpper() + ''',\n",
                "        @columns VARCHAR(256) = ''' + $layerJsonProperties + ''',\n",
                "        @layout_type_id INT = ' + $layerJsonLayout + ', -- LASTVALUES\n",
                "        @last_update_name VARCHAR(50) = ''' + $layerJsonLastUpdateName + ''',\n",
                "        @is_active INT;\n",
                "        \n",
                "SET @is_active = CASE LOWER(''#{ Environment }#'')\n",
                "    WHEN ''production'' THEN 1\n",
                "    WHEN ''acceptance'' THEN 1\n",
                "    ELSE 1\n",
                "END;\n",
                "\n",
                "SET @view_description = CONCAT(''VIEW: '', @view_name, '' FOR '', @item_name);\n",
                "SET @config_description = CONCAT(''VIEW CONFIGURATION: '', @view_name, '' FOR '', @item_name);\n",
                "\n",
                "-- 2) DETERMINE VIEW ID & CONFIGURATION ID\n",
                "DECLARE @constrained INT,\n",
                "        @grouped INT,\n",
                "        @view_id BIGINT,\n",
                "        @config_id BIGINT;\n",
                "\n",
                "SET @constrained = CASE \n",
                "    WHEN @constraint_key_name IS NULL THEN 0\n",
                "    ELSE 1\n",
                "END;\n",
                "SET @grouped = CASE \n",
                "    WHEN @grouped_key_name IS NULL THEN 0\n",
                "    ELSE 1\n",
                "END;\n",
                "\n",
                "DELETE FROM [DATATINO_PROTO_1].[CONFIGURATIONS]\n",
                "WHERE [ID] IN (\n",
                "    SELECT\n",
                "        configs.[ID]\n",
                "    FROM [DATATINO_PROTO_1].[VIEWS] views\n",
                "    INNER JOIN [DATATINO_PROTO_1].[CONFIGURATIONS] AS configs ON views.[ID] = configs.[VIEW_ID]\n",
                "        AND configs.[NAME] = @item_name\n",
                "    INNER JOIN [DATATINO_PROTO_1].[PROTOS] AS protos ON protos.[ID] = configs.[PROTO_ID]\n",
                "        AND protos.[NAME] = @proto_name\n",
                ");\n",
                "\n",
                "SELECT \n",
                "    @view_id = [ID]\n",
                "FROM [DATATINO_PROTO_1].[VIEWS]\n",
                "WHERE ISNULL([CONSTRAINT_VALUE], ''X'') = ISNULL(@constraint_value, ''X'')\n",
                "    AND ISNULL([CONSTRAINT_KEY_NAME], ''X'') = ISNULL(@constraint_key_name, ''X'')\n",
                "    AND ISNULL([GROUPED_KEY_NAME], ''X'') = ISNULL(@grouped_key_name, ''X'')\n",
                "    AND ISNULL([GROUPED_LAST_UPDATE_NAME], ''X'') = ISNULL(@grouped_last_update_name, ''X'')\n",
                "    AND [NAME] = @view_name;\n",
                "\n",
                "SELECT\n",
                "    @config_id = configs.[ID]\n",
                "FROM [DATATINO_PROTO_1].[VIEWS] views\n",
                "INNER JOIN [DATATINO_PROTO_1].[CONFIGURATIONS] AS configs ON views.[ID] = configs.[VIEW_ID]\n",
                "    AND configs.[NAME] = @item_name\n",
                "    AND configs.[VIEW_ID] = @view_id\n",
                "INNER JOIN [DATATINO_PROTO_1].[PROTOS] AS protos ON protos.[ID] = configs.[PROTO_ID]\n",
                "    AND protos.[NAME] = @proto_name\n",
                "WHERE views.[NAME] = @view_name;\n",
                "\n",
                "-- 3) UPSERT PROTO VIEW(S).....\n",
                "EXECUTE [DATATINO_PROTO_1].[UPSERT_VIEW]\n",
                "    @id = @view_id,\n",
                "    @view_name = @view_name,\n",
                "    @description = @view_description,\n",
                "    @last_update_name = @last_update_name,\n",
                "    @constraint_key_name = @constraint_key_name,\n",
                "    @constraint_value = @constraint_value,\n",
                "    @grouped_key_name = @grouped_key_name,\n",
                "    @grouped_last_update_name = @grouped_last_update_name;\n",
                "\n",
                "-- 4) UPSERT PROTO CONFIGURATION(S).....\n",
                "EXECUTE [DATATINO_PROTO_1].[UPSERT_CONFIGURATION]\n",
                "    @id = @config_id,\n",
                "    @proto_name = @proto_name,\n",
                "    @description =  @config_description,\n",
                "    @view_name = @view_name,\n",
                "    @item_name = @item_name,\n",
                "    @constrained = @constrained,\n",
                "    @grouped = @grouped,\n",
                "    @columns = @columns,\n",
                "    @mapping = ''=LOWER()'',\n",
                "    @layout_type_id = @layout_type_id,\n",
                "    @active = @is_active,\n",
                "    @constraint_key_name = @constraint_key_name,\n",
                "    @constraint_value = @constraint_value,\n",
                "    @grouped_key_name = @grouped_key_name,\n",
                "    @grouped_last_update_name = @grouped_last_update_name;\n",
                "GO"
            ]
        }'
    }
}

Write-Host "Create ipynb....."
'{
    "cells": [
        {
            "cell_type": "markdown",
            "metadata": {
                "azdata_cell_guid": "a1bff903-eb61-4e65-82a1-c4e918bbcac8"
            },
            "source": [
                "```sql\n",
                "-- COPYRIGHT (C) ' + $(Get-Date -Format "yyyy") + ' DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.\n",
                "-- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.\n",
                "```\n",
                "\n",
                "# **INTRODUCTIONS**\n",
                "\n",
                "---\n",
                "\n",
                "The code is separated into multiple sections:\n",
                "\n",
                "1. **[Flow Diagrams](#flow-diagrams)**\n",
                "2. **[Dependencies](#dependencies)**\n",
                "3. **[Input Layer](#input-layer)**\n",' + 
                (& { if ($Type -eq 'Protocols') { '"4. **[Intermediate Layer](#intermediate-layer)**\n", "5. **[Ouput Layer](#output-layer)**\n",' } else { '"4. **[Static Layer](#static-layer)**\n",' } } ) +
                '
                "\n",
                "\n",
                "# **FLOW DIAGRAMS**\n",
                "\n",
                "---\n",
                "\n",
                "`ADD DIAGRAM HERE!`\n",
                "\n",
                "Required steps:\n",
                "\n",
                "1. `ADD REQUIRMENT STEP LIST HERE!`",
                "\n",' + 
                (& {if ($Type -eq 'Protocols') { '"- **<font color=teal>IL</font>**: Intermediate Layer\n", "- **<font color=teal>OL</font>**: Output Layer"' } else { '"- **<font color=teal>SL</font>**: Static Layer"' }} ) +
                '
                ]
        },
        {
            "cell_type": "markdown",
            "metadata": {
                "azdata_cell_guid": "5f7eda1c-d087-4bbd-8504-802228776c0d"
            },
            "source": [
                "# **DEPENDENCIES**\n",
                "\n",
                "---\n",
                "\n",
                "```json\n",
                "{\n",
                "    \"depends-on\": [\n",
                "        \"src/Utils/Functions.ipynb\",\n",
                "        \"src/Utils/Schemas.ipynb\",\n",
                "        \"src/Utils/Protos.ipynb\"\n",
                "        // Additional dependencies (!NOTE! DO NOT FORGET THE COMMA (i.e. ,))\n",
                "    ]\n",
                "}\n",
                "```"
            ]
        },
        {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
                "# **INPUT LAYER**\n",
                "\n",
                "---"
            ]
        },
        {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
                "## **<span style=''color:teal''>TABLES</span>**"
            ]
        },
        {
            "cell_type": "code",
            "execution_count": null,
            "metadata": {
                "azdata_cell_guid": "247bfd81-3df9-4f8e-981e-3f5a3dbdc126"
            },
            "outputs": [],
            "source": [
                "SET ANSI_NULLS ON\n",
                "GO\n",
                "\n",
                "SET QUOTED_IDENTIFIER ON\n",
                "GO\n",
                "\n",
                "-- 1) CREATE TABLE(S).....\n",
                "IF NOT EXISTS (SELECT * FROM [SYS].[TABLES] WHERE [OBJECT_ID] = OBJECT_ID(''[VWSSTAGE].['+ $mainTableName + ']''))\n",
                "CREATE TABLE [VWSSTAGE].['+ $mainTableName + '] (\n",
                "\t[ID] [BIGINT] PRIMARY KEY IDENTITY(1,1),\n",
                "\t[DATE_LAST_INSERTED] [DATETIME] DEFAULT GETDATE(),\n",
                "\t-- ADD COLUMNS\n",
                ");\n",
                "GO"
            ]
        },
        {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
                "# **' + (& {if ($Type -eq 'Protocols') { 'INTERMEDIATE' } else { 'STATIC' }}) + ' LAYER**\n",
                "\n",
                "---"
            ]
        },
        {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
                "## **<span style=''color:teal''>TABLES</span>**"
            ]
        },
        {
            "cell_type": "code",
            "execution_count": null,
            "metadata": {},
            "outputs": [],
            "source": [
                "SET ANSI_NULLS ON\n",
                "GO\n",
                "\n",
                "SET QUOTED_IDENTIFIER ON\n",
                "GO\n",
                "\n",
                "-- 1) CREATE TABLE(S).....\n",
                "IF NOT EXISTS (SELECT * FROM [SYS].[TABLES] WHERE [OBJECT_ID] = OBJECT_ID(''[VWSINTER].['+ $mainTableName + ']''))\n",
                "CREATE TABLE [VWSINTER].['+ $mainTableName + '] (\n",
                "\t[ID] [BIGINT] PRIMARY KEY IDENTITY(1,1),\n",
                "\t[DATE_LAST_INSERTED] [DATETIME] DEFAULT GETDATE(),\n",
                "\t-- ADD COLUMNS\n",
                ");\n",
                "GO"
            ]
        },
        {
            "cell_type": "markdown",
            "metadata": {},
            "source": [
                "## **<span style=''color:teal''>STORED PROCEDURES</span>**"
            ]
        },
        {
            "cell_type": "code",
            "execution_count": null,
            "metadata": {},
            "outputs": [],
            "source": [
                "-- 1) CREATE STORED PROCEDURE(S): STAGING TO INTERMEDIATE.....\n",
                "CREATE OR ALTER PROCEDURE [dbo].[SP_INSERT_' + (& { if ($Type -eq 'Protocols') { 'IL' } else { 'SL' } } ) + '_'+ $mainTableName + ']\n",
                "AS\n",
                "BEGIN\n",
                "    INSERT INTO [VWSINTER].['+ $mainTableName + '] (\n",
                "        -- ADD COLUMN NAMES\n",
                "    )\n",
                "    SELECT\n",
                "        -- SELECT COLUMNS \n",
                "    FROM\n",
                "        [VWSSTAGE].['+ $mainTableName + ']\n",
                "    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].['+ $mainTableName + '])\n",
                "END;\n",
                "GO"
            ]
        }' + 
        (& { if ($Type -eq 'Protocols') { ',{
            "cell_type": "markdown",
            "metadata": {},
            "source": [
                "# **OUTPUT LAYER**\n",
                "\n",
                "---"
            ]
        },' + $($_outputLayer -Join ',')} else { $null } } ) +
        '],
    "metadata": {
        "kernelspec": {
            "display_name": "SQL",
            "language": "sql",
            "name": "SQL"
        },
        "language_info": {
            "name": "sql",
            "version": ""
        }
    },
    "nbformat": 4,
    "nbformat_minor": 2
}' | Out-File $outputFile

# }