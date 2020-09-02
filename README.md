# COVID-19 Dashboard Calculations

## Table of Contents
1. [ About the Project ](#about)<br/>
1.1 [ Built With](#build)
2. [Getting Started](#start)<br/>
2.1 [ Have a SQL database available](#sql)<br/>
2.2 [ Install Flyway (Optional)](#flyway)<br/>
2.3 [ Install Datatino Orchestrator & Proto (Optional)](#datatino)
3. [ Usage ](#usage)<br/>
4. [ Disclaimer ](#disc)<br/>
5. [ Development & Contribution process ](#cont)<br/>


<a name="about"></a>
## 1. About the Project

With the information on the dashboard, early signs that the rate of infection is increasing can be picked up. This project describes the definitions and calculations on various indicators to that purpose. See https://coronadashboard.government.nl/verantwoording for even more information on data calculation and presentation for the corona dashboard.
The COVID-19 dashboard figures originate from a number of data sources, which are either combined or used independently. In order to streamline the calculations for the dashboard, each dashboard item has been split into separate data flows.

By means of stored procedures, separate data layers, and end states available in views, the figures are made available to be extracted.


<a name="built"></a>
### 1.1 Built With

- Microsoft SQL Server 2019
- T-SQL
---
<a name="start"></a>
## 2. Getting Started

<a name="sql"></a>
### 2.1 Have a SQL database available
For this project we have made use of Microsoft SQL Server 2019. You are free to choose another database type, but some parts of this project may need adjustments then. If you do not have an on-premise or cloud solution at your disposal, a Docker image has also been made available by [Microsoft](https://hub.docker.com/_/microsoft-mssql-server), which you can also use for initializing the project.

<a name="flyway"></a>
### 2.2 Install Flyway (Optional)
We use Flyway, in order to automate and version our database setup. See the technical documentation for more explanation on this. You can download Flyway [here](https://flywaydb.org/documentation/commandline/).

If you do not want to use Flyway, you can choose a tool of your own liking or exececute the files by hand.

Please make sure you specify a **flyway.conf** file containing the following information.
```
flyway.url={{__SERVER_JDBC_CONNECTION_STRING__}}
flyway.user={{__DB_USER_NAME__}}
flyway.password={{__DB_PASSWORD__}}
flyway.schemas=\
VWSSTAGE,\
VWSSTATIC,\
VWSINTER,\
VWSDEST
flyway.locations=\
filesystem:main/sql/functions,\
filesystem:main/sql/stored_procedures,\
filesystem:main/sql/views,\
filesystem:main/sql/tables/VWSSTATIC,\
filesystem:main/sql/tables/VWSSTAGE,\
filesystem:main/sql/tables/VWSINTER,\
filesystem:main/sql/tables/VWSDEST,\
filesystem:main/sql/data_import/static_data,\
filesystem:main/sql/datatino_configuration/orchestration,\
filesystem:main/sql/datatino_configuration/proto

```
<a name="datatino"></a>
### 2.3 Install Datatino Orchestrator & Proto (Optional)
**Datatino Orchestrator** is used for the automation of the ingestion of data and processing of the data flows. This tool has been made in-house and we are currently working on making it publicly available. We will make a reference to the project when it is open sourced.

The installation of this solution is not a requirement in order to be able to run the calculations. You can also execute the stored procedures, and other filetypes manually, or make use of another solution to your liking. 

**Datatino Proto** is used for generating JSON files based on a defined data selection. This tool has been made in-house and we are currently working on making it publicly available. We will make a reference to the project when it is open sourced. 

You only need this tool if you wish to generate the same JSON files as is used for the dashboard. It is not a requirement to have it available for running calculcations of any sort. 

---
<a name="usage"></a>
## 3. Usage
In the [technical documentation](./technical_doc.md) you can read how an identical data environment can be set up. In order to gain understanding of what the data means, a [functional documentation](./functional_doc.md) has also been made available.

If you want to know how you could add new data items yourself, an instruction on this can be found [here](./main/sql/README.md).

<a name="disc"></a>
## 4. Disclaimer
This dashboard is developed and maintained by a different team than the NL COVID19 Notification App. They are separate projects. If you want to get in touch with the team, please join the CODE for NL Slack and join the channel #coronadashboard.

Tamas Erkelens from the Municipality of Amsterdam is contact person for the project team that made the dashboard.

[CODE For NL Slack](https://doemee.codefor.nl)

<a name="cont"></a>
## 5. Development & Contribution process
The core team works directly from this open-source repository. If you plan to propose changes, we recommend to open an issue beforehand where we can discuss your planned changes. This increases the chance that we might be able to use your contribution (or it avoids doing work if there are reasons why we wouldn't be able to use it).
