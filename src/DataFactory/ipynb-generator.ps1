param (
    # [PSCustomObject[]] $OutputLayers = @{ Name = "<LayerName>"; ProtoName = "<NL|VR_COLLECTION|GM_COLLECTION>"; ItemName = "<json-key>"; Columns = "<*|COLUMN_NAMES>"; LayoutTypeId = "<1|2|3|4>"; LastUpdateName = "<COLUMN_NAME>"; ConstraintValue = "<NULL>"; ConstraintKeyName = "<NULL|COLUMN NAME>"; GroupedKeyName = "<NULL|COLUMN NAME>"; GroupedLastUpdateName = "<NULL|COLUMN NAME>" },
    [PSCustomObject[]] $OutputLayers = @{},
    [Parameter(Mandatory = $true)][String] $InputEntity = "<RIVM|CBS|LCPS|NIVEL>",
    [Parameter(Mandatory = $true)][String] $IPynbName,
    [Parameter(Mandatory = $true)][String] $IPynbType = "Protocols"
)

$ErrorActionPreference = "Stop"

### Set Variables

$tableName = $($InputEntity + $($IPynbName -creplace '([A-Z\W]|\d+)(?<![a-z])', '_$&' ).Trim()).ToUpper();

$fs = "src/DataFactory/$($IPynbType)/pl_Process$($IPynbName).ipynb";

function Set-Sections {
    switch ($IPynbType.ToLower()) {
        "protocols" { 
            return '"4. **[Intermediate Layer](#intermediate-layer)**\n", "5. **[Ouput Layer](#output-layer)**\n",';
        }
        "statics" {
            return '"4. **[Static Layer](#static-layer)**\n",';
        }
        Default {}
    }
}

function Set-Legend {
    switch ($IPynbType.ToLower()) {
        "protocols" { 
            return '"- **<font color=teal>IL</font>**: Intermediate Layer\n", "- **<font color=teal>OL</font>**: Output Layer"';
        }
        "statics" {
            return '"- **<font color=teal>SL</font>**: Static Layer\n"';
        }
        Default {}
    }
}

function Set-LayerType {
    switch ($IPynbType.ToLower()) {
        "protocols" { 
            return "INTERMEDIATE";
        }
        "statics" {
            return "STATIC";
        }
        Default {}
    }
}

function Set-Schema {
    switch ($IPynbType.ToLower()) {
        "protocols" { 
            return "VWSINTER";
        }
        "statics" {
            return "VWSSTATIC";
        }
        Default {}
    }
}

function Set-SProcType {
    switch ($IPynbType.ToLower()) {
        "protocols" { 
            return "IL";
        }
        "statics" {
            return "SL";
        }
        Default {}
    }
}

# Template Functions
function Set-MarkdownSnippet {
    param (
        [System.String] $Source
    )

    return '{
        "cell_type": "markdown",
        "metadata": {},
        "source": [
            ' + $Source + '
        ]
    }';
}

function Set-CodeSnippet {
    param (
        [System.String] $Source
    )
    
    return '{
        "cell_type": "code",
        "execution_count": null,
        "metadata": {},
        "outputs": [],
        "source": [' + $Source + ']
    }';
}

function Set-OutputLayers {
    param (
        [PSCustomObject[]] $Layers
    )

    $subLayers = $Layers | Where-Object { $null -ne $_.Name } | ForEach-Object {
        $protoName = $_.ProtoName?.ToUpper()?.Replace(" ", "_");
        $name = $InputEntity + "_" + ($_.Name?.ToUpper() + "_" + $protoName).Replace(" ", "_");
        $itemName = $_.ItemName?.ToLower()?.Replace(" ", "_");

        $layoutTypeId = $_.LayoutTypeId;
        if ($null -eq $layoutTypeId) {
            $layoutTypeId = "`'<1|2|3|4>`'";
        } 

        $lastUpdateName = $_.LastUpdateName?.ToUpper();
        if ($null -eq $lastUpdateName) {
            $lastUpdateName = "e.g DATE_UNIX"
        } 

        $columns = $_.Columns?.ToUpper();
        if ($null -eq $columns) {
            $columns = "*"
        } 

        $constraintValue = $_.ConstraintValue?.ToUpper();
        if ($null -eq $constraintValue) {
            $constraintValue = "NULL"
        } elseif ($constraintValue -ne "NULL") {
            $constraintValue = '"' + $constraintValue + '"'
        }      

        $constraintKeyName = $_.ConstraintKeyName?.ToUpper();
        if ($null -eq $constraintKeyName) {
            $constraintKeyName = "NULL"
        } elseif ($constraintKeyName -ne "NULL") {
            $constraintKeyName = '"' + $constraintKeyName + '"'
        }

        $groupedKeyName = $_.GroupedKeyName?.ToUpper();
        if ($null -eq $groupedKeyName) {
            $groupedKeyName = "NULL"
        } elseif ($groupedKeyName -ne "NULL") {
            $groupedKeyName = '"' + $groupedKeyName + '"'
        }

        $groupedLastUpdateName = $_.GroupedLastUpdateName?.ToUpper();
        if ($null -eq $groupedLastUpdateName) {
            $groupedLastUpdateName = "NULL"
        } elseif ($groupedLastUpdateName -ne "NULL") {
            $groupedLastUpdateName = '"' + $groupedLastUpdateName + '"'
        }

        $subLayer = [System.Text.StringBuilder]::new();
        return $subLayer.AppendJoin(",",                
            $(Set-MarkdownSnippet('"## **<span style=''color:teal''>' + $_.Name?.ToUpper() + " " + $_.ProtoName?.ToUpper() + '</span>**"')),
            $(Set-MarkdownSnippet('"### **<span style=''color:cadetblue''>TABLES</span>**"')),
            $(Set-CodeSnippet('"SET ANSI_NULLS ON\n",
                    "GO\n",
                    "\n",
                    "SET QUOTED_IDENTIFIER ON\n",
                    "GO\n",
                    "\n",
                    "-- 1) CREATE TABLE(S).....\n",
                    "IF NOT EXISTS (SELECT * FROM [SYS].[TABLES] WHERE [OBJECT_ID] = OBJECT_ID(''[VWSDEST].['+ $name + ']''))\n",
                    "CREATE TABLE [VWSDEST].['+ $name + '] (\n",
                    "\t[ID] [BIGINT] PRIMARY KEY IDENTITY(1,1),\n",
                    "\t[DATE_LAST_INSERTED] [DATETIME] DEFAULT GETDATE(),\n",
                    "\t-- ADD COLUMNS\n",
                    ");\n",
                    "GO\n",
                    "\n",
                    "-- 2) CREATE INDEX(S).....\n",
                    "DROP INDEX IF EXISTS [NCIX_DLI_'+ $name + '] \n",
                    "\tON [VWSDEST].['+ $name + ']\n",
                    "GO\n",
                    "\n",
                    "CREATE NONCLUSTERED INDEX [NCIX_DLI_'+ $name + ']\n",
                    "    ON [VWSDEST].['+ $name + '] (\n",
                    "\t\t[DATE_LAST_INSERTED]\n",
                    "\t)\n",
                    "GO"'
                )
            ),
            $(Set-MarkdownSnippet('"### **<span style=''color:cadetblue''>STORED PROCEDURES</span>**"')),
            $(Set-CodeSnippet('"-- 1) CREATE STORED PROCEDURE(S): ' + $(Set-LayerType) + ' TO DESTINATION.....\n",
                    "CREATE OR ALTER PROCEDURE [dbo].[SP_INSERT_OL_'+ $name + ']\n",
                    "AS\n",
                    "BEGIN\n",
                    "    INSERT INTO [VWSDEST].['+ $name + '] (\n",
                    "        -- ADD COLUMN NAMES\n",
                    "    )\n",
                    "    SELECT\n",
                    "        -- SELECT COLUMNS \n",
                    "    FROM\n",
                    "        [VWSINTER].['+ $tableName + ']\n",
                    "    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSINTER].['+ $tableName + '])\n",
                    "END;\n",
                    "GO"'
                )
            ),
            $(Set-MarkdownSnippet('"### **<span style=''color:cadetblue''>VIEWS</span>**"')),
            $(Set-CodeSnippet('"-- 1) CREATE VIEW(S).....\n",
                    "CREATE OR ALTER VIEW [VWSDEST].[V_'+ $name + '] AS\n",
                    "WITH CTE AS (\n",
                    "    SELECT\n",
                    "        -- SELECT COLUMNS\n",
                    "    FROM [VWSDEST].['+ $name + '] WITH(NOLOCK)\n",
                    "    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSDEST].['+ $name + '] WITH(NOLOCK))\n",
                    ")\n",
                    "SELECT\n",
                    "    *\n",
                    "FROM CTE\n",
                    "GO"'
                )
            ),
            $(Set-MarkdownSnippet('"### **<span style=''color:cadetblue''>VIEWS | CONFIGURATION</span>**"')),
            $(Set-CodeSnippet('"-- 1) SET ENVIRONMENTAL VARIABLES.....\n",
                    "DECLARE @view_name VARCHAR(256) = ''VWSDEST.V_'+ $name + ''',\n",
                    "        @view_description VARCHAR(256),\n",
                    "        @item_name VARCHAR(256) = '''+ $itemName + ''',\n",
                    "        @config_description VARCHAR(256),\n",
                    "        @constraint_value VARCHAR(50) = ' + $constraintValue + ',\n",
                    "        @constraint_key_name VARCHAR(50) = ' + $constraintKeyName + ',\n",
                    "        @grouped_key_name VARCHAR(50) = ' + $groupedKeyName + ',\n",
                    "        @grouped_last_update_name VARCHAR(50) = ' + $groupedLastUpdateName + ',\n",
                    "        @proto_name VARCHAR(50) = ''' + $protoName + ''',\n",
                    "        @columns VARCHAR(256) = ''' + $columns + ''',\n",
                    "        @layout_type_id INT = ' + $layoutTypeId + ',\n",
                    "        @last_update_name VARCHAR(50) = ''' + $lastUpdateName + ''',\n",
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
                    "GO"'
                )
            )
        )
    }

    if ($subLayers.Count -ne 0) {
        return ((Set-MarkdownSnippet('"# **OUTPUT LAYER**\n", "\n", "---"')) + "," + $($subLayers -Join ","))
    } else {
        $null
    }
}

# Creating .IPynb Files

if (Test-Path $fs) {
    Write-Error "IPynb already created...
Remove already existing Notebook: $($fs)
and re-run the script...";
}
else {
    $sb = [System.Text.StringBuilder]::new();

    $sb.Append('{ "cells": [');
    [Void] $sb.AppendJoin(",",        
        # Introduction
        $(Set-MarkdownSnippet('"```sql\n", "-- COPYRIGHT (C) ' + $(Get-Date -Format "yyyy") + ' DE STAAT DER NEDERLANDEN, MINISTERIE VAN VOLKSGEZONDHEID, WELZIJN EN SPORT.\n", "-- LICENSED UNDER THE EUROPEAN UNION PUBLIC LICENCE V. 1.2 - SEE HTTPS://GITHUB.COM/MINVWS/NL-CONTACT-TRACING-APP-COORDINATIONFOR MORE INFORMATION.\n", "```\n", "\n", "# **INTRODUCTIONS**\n", "\n", "---\n", "\n", "The code is separated into multiple sections:\n", "\n", "1. **[Flow Diagrams](#flow-diagrams)**\n", "2. **[Dependencies](#dependencies)**\n", "3. **[Input Layer](#input-layer)**\n", ' + $(Set-Sections) + '"\n", "\n", "# **FLOW DIAGRAMS**\n", "\n", "---\n", "\n", "`ADD DIAGRAM HERE!`\n", "\n", "Required steps:\n", "\n", "1. `ADD REQUIRMENT STEP LIST HERE!`", "\n",' + $(Set-Legend))),
        $(Set-MarkdownSnippet('"# **DEPENDENCIES**\n", "\n", "---\n", "\n", "```json\n", "{\n", "    \"depends-on\": [\n", "        \"src/Utils/Functions.ipynb\",\n", "        \"src/Utils/Schemas.ipynb\",\n", "        \"src/Utils/Protos.ipynb\"\n", "        // Additional dependencies (!NOTE! DO NOT FORGET THE COMMA (i.e. ,))\n", "    ]\n", "}\n", "```"') ),
        # Input Layer
        $(Set-MarkdownSnippet('"# **INPUT LAYER**\n", "\n", "---"') ),
        $(Set-MarkdownSnippet('"## **<span style=''color:teal''>TABLES</span>**"')),
        $(Set-CodeSnippet('"SET ANSI_NULLS ON\n",
            "GO\n",
            "\n",
            "SET QUOTED_IDENTIFIER ON\n",
            "GO\n",
            "\n",
            "-- 1) CREATE TABLE(S).....\n",
            "IF NOT EXISTS (SELECT * FROM [SYS].[TABLES] WHERE [OBJECT_ID] = OBJECT_ID(''[VWSSTAGE].['+ $tableName + ']''))\n",
            "CREATE TABLE [VWSSTAGE].['+ $tableName + '] (\n",
            "\t[ID] [BIGINT] PRIMARY KEY IDENTITY(1,1),\n",
            "\t[DATE_LAST_INSERTED] [DATETIME] DEFAULT GETDATE(),\n",
            "\t-- ADD COLUMNS\n",
            ");\n",
            "GO"'
            )
        ),
        # Intermediate/Static Layer
        $(Set-MarkdownSnippet('"# **' + $(Set-LayerType) + ' LAYER**\n", "\n", "---"')),
        $(Set-MarkdownSnippet('"## **<span style=''color:teal''>TABLES</span>**"')),
        $(Set-CodeSnippet('
            "SET ANSI_NULLS ON\n",
            "GO\n",
            "\n",
            "SET QUOTED_IDENTIFIER ON\n",
            "GO\n",
            "\n",
            "-- 1) CREATE TABLE(S).....\n",
            "IF NOT EXISTS (SELECT * FROM [SYS].[TABLES] WHERE [OBJECT_ID] = OBJECT_ID(''[' + $(Set-Schema) + '].[' + $tableName + ']''))\n",
            "CREATE TABLE [' + $(Set-Schema) + '].[' + $tableName + '] (\n",
            "\t[ID] [BIGINT] PRIMARY KEY IDENTITY(1,1),\n",
            "\t[DATE_LAST_INSERTED] [DATETIME] DEFAULT GETDATE(),\n",
            "\t-- ADD COLUMNS\n",
            ");\n",
            "GO"'
            )
        ),
        $(Set-MarkdownSnippet('"## **<span style=''color:teal''>STORED PROCEDURES</span>**"')),
        $(Set-CodeSnippet('"-- 1) CREATE STORED PROCEDURE(S): STAGING TO ' + $(Set-LayerType) + '.....\n",
            "CREATE OR ALTER PROCEDURE [dbo].[SP_INSERT_' + $(Set-SProcType) + '_' + $tableName + ']\n",
            "AS\n",
            "BEGIN\n",
            "    INSERT INTO [' + $(Set-Schema) + '].[' + $tableName + '] (\n",
            "        -- ADD COLUMN NAMES\n",
            "    )\n",
            "    SELECT\n",
            "        -- SELECT COLUMNS \n",
            "    FROM\n",
            "        [VWSSTAGE].['+ $tableName + ']\n",
            "    WHERE [DATE_LAST_INSERTED] = (SELECT MAX([DATE_LAST_INSERTED]) FROM [VWSSTAGE].['+ $tableName + '])\n",
            "END;\n",
            "GO"'
            )
        ),
        # Output Layer
        $(Set-OutputLayers -Layers $OutputLayers)
    );

    $sb.ToString().Trim(",") + '], "metadata": {
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
        }' | Out-File $fs
}