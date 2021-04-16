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
This project aims to describes the definitions and calculations of various covid related
indicators present on the national corona dashboard. Supplementary information can be 
found at https://coronadashboard.rijksoverheid.nl/verantwoording. A variety of data 
sources is used to calculate the various indicators. Some indicators are calculated 
using a single data source, others require a combination of data sources. The calculation of indicators
is logically split in separate workflows.

<a name="built"></a>
### 1.1 Built With

- Microsoft SQL Server 2019
- T-SQL
---
<a name="start"></a>
## 2. Getting Started

<a name="sql"></a>
### 2.1 Have a SQL database available
A Microsoft SQL Server 2019 is used in this project. A docker image can be used if no 
on-premise or cloud solution is available ([Microsoft](https://hub.docker.com/_/microsoft-mssql-server). 
Mind you: deviating from these build parameters will most likely result in a different working solution.

<a name="flyway"></a>
### 2.2 Install Flyway (Optional)
Flyway is used to automate and version the database setup. See the technical 
documentation for more explanation. [here](https://flywaydb.org/documentation/commandline/).

The **flyway.conf** file should contain the following information.
```
flyway.url=jdbc:sqlserver://<server>:1433;Database=<database>
flyway.user=<db-user>
flyway.password=<db-password>
flyway.schemas=\
VWSARCHIVE,\
VWSSTAGE,\
VWSSTATIC,\
VWSINTER,\
VWSDEST,\
VWSMISC
flyway.locations=filesystem:main/sql/
```
<a name="datatino"></a>
### 2.3 Install Datatino Orchestrator & Proto (Optional)
To schedule and automate the ingestion and processing of data sources a solution has 
been created and used: **Datatino Orchestrator** (publicly available soon). 
However the user could use a different schedule and automate solution (or do it by hand).

After the covid indicators are calculated **Datatino Proto** (Short for Protocol, publicly available soon) 
is used to package the results in a predefined and desired (human readable) manner.
---
<a name="usage"></a>
## 3. Usage
How to create an identical (data) environment is shown in [technical documentation](./technical_doc.md)
To gain a better understanding of the data: [functional documentation](./functional_doc.md) has also been made available.
An instruction on how to add new indicators can be found in [here](./main/sql/README.md) 

<a name="disc"></a>
## 4. Disclaimer
One can get in touch with the development team by joining the CODE for NL Slack, channel: #coronadashboard.
Tamas Erkelens (from the Municipality of Amsterdam) is the main contact person for the project team.
Mind you: This is not the same development team that created the NL COVID19 Notification App

[CODE For NL Slack](https://doemee.codefor.nl)

<a name="cont"></a>
## 5. Development & Contribution process
The core team works directly from this open-source repository. If you want to make a 
contribution we recommend opening an issue first in order to avoid the situation where 
we already have your contribution staged or can't use your contribution due to certain 
causes.
