
# Adding new data
In the current set-up of the project, adding new data and adding that data to the process are two different steps. 
1. First a set-up is created in the database to enable the storage of the staging, intermediate and destination tables as well as the view to read the output from the destination table. If required in the process the transformations if done in stored procedures can also be added to the database.
2. The datatino-run-configuration for the run of the new data-flow should be added. As described before the project depends on a sql-based-scheduler, this scheduler should be told where to get new data, how to promote the data to the different tables and what data should be used to generate new output-files.

<em> Note: if you choose to not make use of the datatino-packages, the data-import of the run-configuration can be ignored </em>

## 1. Adding the required database elements for the data-flow
<em> Note: this explanation is for now specific for the use of stored procedures as transformations, other transformations are possible, but not yet described. </em>

### create the required table structures
Start by adding the staging tables to the database. These can be found in [/main/sql/tables/](/main/sql/tables/). The fields in this table will directly correlate to the json file that is supposed to be ingested, so ensure correct naming. To prevent type clashes, read all data as strings. Note that the ID and the DATE_LAST_INSERTED for data validation purposes. The orchestration will read and insert data directly into this table.
````
-- Example staging table
IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSSTAGE_EXAMPLE]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSSTAGE_EXAMPLE
    START WITH 1
    INCREMENT BY 1;
GO

CREATE TABLE VWSSTAGE.EXAMPLE(
    [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSSTAGE_EXAMPLE]),
    [EXAMPLE_FIELD_ONE] VARCHAR(100),
    [EXAMPLE_FIELD_TWO] VARCHAR(100),
    [EXAMPLE_FIELD_THREE] VARCHAR(100),
    DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
    );
````

Secondly by creating intermediate tables which can be used to execute the data transformation. It is a good idea to ensure that from these tables on, the correct typing is used. Casting can be done implicitly or explicitly.

````
-- Example intermediate table
IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSINTER_EXAMPLE]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSINTER_EXAMPLE
  START WITH 1
  INCREMENT BY 1;
GO

CREATE TABLE VWSINTER.EXAMPLE(
    [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSINTER_EXAMPLE]),
    [EXAMPLE_FIELD_ONE] VARCHAR(100) NOT NULL,
    [EXAMPLE_FIELD_TWO] INT NOT NULL,
    [EXAMPLE_FIELD_THREE] DECIMAL(16,1) NULL,
    DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
);

````

Lastly by creating the destination table to store the end results of the data transformation(s). This table will be used by the views to fetch the data.
````
-- Production table for example results
IF NOT EXISTS(SELECT * FROM sys.sequences WHERE object_id = OBJECT_ID(N'[dbo].[SEQ_VWSDEST_EXAMPLE]') AND type = 'SO')
CREATE SEQUENCE SEQ_VWSDEST_EXAMPLE
  START WITH 1
  INCREMENT BY 1;
GO

 CREATE TABLE VWSDEST.EXAMPLE(
    [ID] INT PRIMARY KEY NOT NULL DEFAULT (NEXT VALUE FOR [dbo].[SEQ_VWSDEST_EXAMPLE]),
    [EXAMPLE_FIELD_ONE] VARCHAR(100) NOT NULL,
    [EXAMPLE_FIELD_TWO] INT NOT NULL,
    [EXAMPLE_FIELD_THREE] DECIMAL(16,1) NULL,
    DATE_LAST_INSERTED DATETIME DEFAULT GETDATE()
 );
````

### create the optional stored procedures and required output-views 

Create a stored procedure to move data from the staging table(s) to intermediate table(s). Ensure that the types are correctly cast or transformed in this procedure.
````
-- Move data from staging to intermediate table.
CREATE OR ALTER PROCEDURE DBO.SP_EXAMPLE_INTER AS
BEGIN
    INSERT INTO VWSINTER.EXAMPLE
        ([EXAMPLE_FIELD_ONE], [EXAMPLE_FIELD_TWO], [EXAMPLE_FIELD_THREE])
    SELECT 
        [EXAMPLE_FIELD_ONE], 
        CAST([EXAMPLE_FIELD_TWO] AS INT),
        CAST([EXAMPLE_FIELD_THREE] AS DECIMAL(16,1))
    FROM VWSSTAGE.EXAMPLE
    WHERE DATE_LAST_INSERTED = (SELECT MAX(DATE_LAST_INSERTED) FROM VWSSTAGE.EXAMPLE)
END;
````
Create a view that represents a field of data within the json file. Add additional data filters here. For example, if we only want data after a certain data, or we do not want to show negative values to the users.

````
-- Example view
CREATE VIEW VWSDEST.V_EXAMPLE AS
SELECT 
    [EXAMPLE_FIELD_ONE],
    [EXAMPLE_FIELD_TWO],
    [EXAMPLE_FIELD_THREE]
FROM VWSDEST.EXAMPLE
    WHERE [DATE_LAST_INSERTED] > '2020-01-01 00:00:00.000'
````


## 2. Adding new configuration data to run the data-flow
The framework creates the configuration based on 2 major steps **Data Transformation** and **Output File generation**.
1. During the Data transformation the transformation is defined by workflows and processes within the workflows, both are sql-tables and a new data-flow should be added to those tables.
2. The output file generation is defined in what we named as 'protos' (JSON files), the configurations of the JSON files and the views used to gather data for the JSON files.

<em>**Important note:** While you are adding new files to the project directory, ensure that the file naming adheres to the flyway guidelines. Not doing this properly will result into your files not being added to the database configuration.</em>

#### 1. Add configuration data to enable the data transformations

Add the new workflow in [configurations](main/sql/datatino_configuration/orchestration/V1_5_1__Add_DT_Configuration_Workflows.sql), like the already existing file, but with a higher version number. 
````
exec [dbo].[SafeInsertWorkflow] 'CASUS_NATIONAL', 'Day', 'N';

-- Reads as: I want to add a workflow named 'CASUS_LANDELIJK', have it run on a daily basis, and I do not want to re-run after 3 failed runs.
````

Add the required processes in [configurations](main/sql/datatino_configuration/orchestration/V1_5_2__Add_DT_Configuration_Processes.sql), like the already existing file, but with a higher version number.
````
exec [dbo].[SafeInsertProcess] 'Load_Case_National', 'Loads Case National Data', 'RIVM_COVID_19_CASE_NATIONAL', 'https://data.rivm.nl/covid-19/COVID-19_casus_landelijk.json', 'VWSSTAGE.RIVM_COVID_19_Case_National', 'NA', 'Web', 'Ingest', 1

-- Reads as: I want a process that loads data from the given URL into the stated table.
````

#### 2. Add datatino-run-configuration data to enable the output file generation

#### Output File Generation

Add the datatino view configuration, like the file [V1_6_2__Add_DT_Configuration_Views.sql](main/sql/datatino_configuration/proto/V1_6_2__Add_DT_Configuration_View.sql), but with a higher version number. This object will fetch data from the SQL view function we wrote earlier. If the view function contains more values than a single key-value list, multiple datatino view configurations can be made to create multiple lists out of the single view function.
````
exec [dbo].[SafeInsertView] 'VWSDEST.VWSDEST.V_EXAMPLE', 'EXAMPLE_FIELD_ONE'
-- Reads as: From this view, use the stated field as key to search for the latest 
````


If an additional json file is required, add a new proto. You can do this like the file [V1_6_1__Add_DT_Configuration_Proto.sql](main/sql/datatino_configuration/proto/V1_6_1__Add_DT_Configuration_Proto.sql), but with a higher version number. Use one of the existing protocols if a new field has to be added to an existing json file.
````
exec [dbo].[SafeInsertProto] 'EXAMPLE', 'name|code', 'Example1|EX1', 'true';

-- Reads as: I want a JSON file with (file) name 'EXAMPLE', and two header keys, 'name' and 'code' with corresponding values 'Example1' and 'EX1'.
````

Add the proto configuration, like in the file: [V1_6_3__Add_DT_Configuration_Protos.sql](main/sql/datatino_configuration/proto/V1_6_3__Add_DT_Configuration_Protos.sql), but with a higher version number. The protocol configuration will add a json field to the protocol (json file). Additionally, you are able to add constraints to the results of the view here. 
````
exec [dbo].[SafeInsertProtoConfiguration] 'EXAMPLE', 'example_key', 'VWSDEST.V_EXAMPLE', 'false', NULL, NULL, 'false', NULL, NULL, 'true';

-- Reads as: I want to add configurations for proto 'EXAMPLE' (defined above), and I want it to have a key that has the name 'example_key'. This key gets its values from the view 'VWSDEST.V_EXAMPLE' and it the view does not need to be filtered or grouped, and it is active for use.
````
