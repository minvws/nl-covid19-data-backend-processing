
# Introduction
This is the technical documentation of the SQL module. 
The module was developed on a mssql database, so if another database is used some of the functionality might need adjustments.

# Datatino dependency
The project Datatino (and mainly the modules orchestrator and proto) are used for the scheduling-configuration and run-configuration of this project. That means that this project uses some tables from that project to store the project specific configuration in. The other tables, functions, stored procedures and data-imports within this project are specific for this project and only provide the bases for the transformation and calculations required to eventually form the output.

# DB-schemas

1. VWSSTAGE: drop location for new data. The data-schemes of this schema are equivalent to the data-schemes of the input-files. The columns are mostly of type varchar, to make sure the loading of data will less likely be a problem. 
2. VWSINTER: first harmonisation step of the new data. The column-names are often equal to the original input-files, but already some changes are made to the types (e.g. varchar to float) and data is trimmed, to prevent errors based on preceeding or tailing spaces. 
3. VWSDEST: this is the schema which holds the destination folder, which is the data from which the views read to create the data for the front-end.
4. DATATINO/DATATINO_ORCHESTRATOR/DATATINO_PROTO: these schemas are used for the configuration of the workflow orchestration and json file generation. The table creation files are available in the datatino-projects, this project requires those to already be available before importing the data during the flyway migration.
5. dbo: default schema where the functions and stored procedures are located.
6. TEST: this schema is only available in the test-phase and is thereby not available in the production environment. This schema holds the unit-tests and the utility stored procedures.
7. VWSSTATIC: this schema only contains static data, as the name implies, and contains data such as number of inhabitants or mapping of municipilaty codes to safety region codes.

# FLYWAY versioning

In this project a database versioning tool was used (Flyway). This tool creates the opportunity to store and keep track of the all changes made to your database based on a series of files and their version-numbers. In this project two different flyway types are used, the versioned-migrations and the repeated migrations. The versioned-migration files start with the letter V and a version number; The repeated-migration files start with the letter R and as there is no history kept in these files there is no version number added. 

The files have a fixed naming convention: V{version}.{schema-id}.{file-id}__{file-name}.sql

1. Versioning: the version of this specific sql-file
2. Schema-id: the reference to the DB-schema
3. File-id: the reference to the file

For installation and other tips and tricks go to 'https://flywaydb.org/'
For updating the database of your choice:
1. Update the flyway.conf
2. Run from the terminal (from the root of this project):
''' flyway migrate '''
3. This should result in an up to date database structure, the newest data is not loaded with this command.

Below you can find an example flyway configuration.

```
flyway.url=
flyway.user=
flyway.password=
flyway.schemas=
flyway.locations=
```

## Error Handling

If any of the stored procedures encounters data which was not expected, the stored procedure will stop and will not continue producing data. The process triggering the stored procedure is responsible for the error-handling. If a human is triggering the stored procedure they should look into the errors, if datatino is used for the triggering of flows, the error-handling is integrated in the datatino-projects and notifications or warnings will be represented in the logs of those projects. 

### Dependencies
* Install [Flyway](https://flywaydb.org/documentation/commandline/): used for the database setup, see above explanation.
* Install [Docker](https://docs.docker.com/get-docker/): the tests are performed within a container to create a constant ready-to-use environment.

## Build and Run

1. Install your database engine and create a database (preferable SQL Server).

2. You can use the Dockerfile stated in the root folder to create a database as is used in this project. The Orchestrator and Proto projects are not yet published and thus not able to be cloned. Also, you will not be able to gather historical data from a database, so you would need to remove these statements from the bash script.

3. You are able to start loading/inserting the source data. Utilize the Datatino.Orchestrator project for this. This step will only insert the data into the database.

4. After the data was successfully loaded, you are able to generate the json files and place them on the file share. Execute Datatino.Proto for this.

## Adding new data

Check the [README](./main/sql/README.md) for more information about adding sources and new data fields to the processing pipeline.