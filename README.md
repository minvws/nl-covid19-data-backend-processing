# **NL CORONAVIRUS DASHBOARD**

---

The **[Coronadashboard](https://coronadashboard.rijksoverheid.nl)** provides information on the breakout and prevalence of the *Coronavirus* in The Netherlands. It combines measured and modelled indicators from various sources to give a broad perspective on the subject. See **[documentation](docs/)** for more information.

This repository includes all the business logic for the data-processing from source data to .json files in the form of the archive `protos.zip`. This `protos.zip` archive is ingested by the front-end application to display all the data on the Coronadashboard. The code for the front-end application can be found **[here](https://github.com/minvws/nl-covid19-data-dashboard)**.

The Coronadashboard was taken offline on 2024-04-02 and now redirects to the RIVM website containing information about Corona.

## **Getting Started**

---

The CoronaDashboard aggregates data from various sources into a single database, which it then provides to a frontend solution. This aggregation happens in three stages: 
* Staging, the raw data from the source
* Intermediate, basic type conversions applied on the raw data
* Destination, data has been processed into a form that is ready for consumption

All calculations and data-manipulations (usually constrained to *one* specific workflow) are described as stored procedures in **Microsoft SQL** (i.e., MSSQL) scripts. An orchestrator is in charge of running the correct stored procedures based on the configuration tables located in the DATATINO_ORCHESTRATOR_1 schema. For some exceptional flows, Azure Data Factory is used as an orchestrator instead (see the ./src/adf-flows/pipeline directory for the definitions of the pipelines to understand which stored procedures belong together).

The configuration tables located in the DATATINO_PROTO_1 schema can be used to map the views from the VWSDEST schema into separate json files that are ready for consumption by a frontend. 

### **Relational Databases**

A **[Microsoft SQL Server 2019](https://www.microsoft.com/en-us/evalcenter/evaluate-sql-server-2019)** is used to ingest and digest the various sources. **Container images** - using **[Docker](https://docs.docker.com/engine/install/)**, **[minikube](https://minikube.sigs.k8s.io/docs/start/)**, **[Podman](https://podman.io/getting-started/)** or Docker runtimes that support **[Docker CLI](https://community.chocolatey.org/packages/docker-cli)**) can be used used when on-premise or cloud solution are not available during development (**[Docker Hub](https://hub.docker.com/_/microsoft-mssql-server)**). It is also possible to run a local version of MSSQL for development purposes.

* Deploy the SQL project in ./src/sln/CoronaDashboard.BusinessLogic/CoronaDashboard.BusinessLogic.Database to the created database. 
* Then fill the configuration tables via the PowerShell load-protos-script.ps1 and load-workflow-configs.ps1 scripts located in ./.devops/scripts directory. 
  * The scripts make use of the configurations as stored in .json files in the ./.devops/configs directory.
* All input source files as of the archiving of the application have been provided in the ./src/input-sources directory in a zip-file named ArchivingCDBsources.7z.
### **Troubleshooting**

---

|Name|Description|Why?|
|--|--|--|
|`PowerShell 7+`|Install the latest version of **[PowerShell](https://www.delftstack.com/howto/powershell/update-windows-powershell/)**.|Older version of PowerShell do not support chained commands (i.e., `&&`) and Null coalescing operators (i.e., `??`). 

**<font color="red">NOTE!</font>** Every time the code has been modified, publish the changes to your local database.

### **Extract Load Transform**

To schedule, and automate, the ingestion and digestion of the indicators, a custom application (i.e **[Datatino Orchestrator](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_git/nl-cdb-be-apis)**) and **[PowerApp](https://powerapps.microsoft.com/en-us/)** are used. However a different schedule and automation solution (or manually) can be used, for example **[Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/introduction)**.

After the indicators are calculated, **[Datatino Protocols](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_git/nl-cdb-be-apis)** (i.e., Proto) are used to package the results in predefined and desired (human readable) `JSON` documents.

> Powershell

```powershell
# Create protos (i.e. JSON formatted documents)
$body = @{
    protoPath = "datatino/test"
    zipPath = "datatino/testzip"
    zipFileName = "protos.zip"
    refreshProtos = $true
};

$parameters = @{
    Method = "POST"
    Uri =  "https://<azure-function>.azurewebsites.net/api/a_proto_zipprotos"
    Body = ($body | ConvertTo-Json) 
    ContentType = "application/json"
};

Invoke-RestMethod @parameters;
```

### **CI/CD PIPELINES**

**[Azure DevOps CI/CD Pipelines](./.devops)** are used to build executable `Transact-SQL` (i.e. `T-SQL`) scripts and release these scripts to their respective environment (i.e. `Development`, `Acceptance` and `Production`).

### **Troubleshooting**

---

When running into CI/CD issues (e.g. Ip Address restrictions), use the following command to start listening for `Azure DevOps` jobs with self-hosted agents - on a machine with the right permissions:

> Powershell

```powershell
# Set variables
$TAG="local-agent"
$DEVOPS_SERVER_INSTANCE_URL="https://dev.azure.com/VWSCoronaDashboard"
$DEVOPS_AGENT_TOKEN="<Personal Access Token>"

# Create local image
$CONTEXT_DIR="./.agents"
docker build -t $TAG -f "$CONTEXT_DIR/Dockerfile" $CONTEXT_DIR

# Run local image as container with the required PAT and URL.
docker run `
    -e DEVOPS_SERVER_INSTANCE_URL=$DEVOPS_SERVER_INSTANCE_URL `
    -e DEVOPS_AGENT_TOKEN=$DEVOPS_AGENT_TOKEN `
    --restart unless-stopped `
    -d `
    $TAG
```

See **[Self-Hosted Agent Container](./.agents)** and **[Micosoft Docs](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops)** for more information.


## **DEVELOPMENT PROCESS**

---

The core team aims to define and calculate various related indicators which are ultimately presented on **[Corona Dashboard](https://coronadashboard.rijksoverheid.nl)**. Some indicators are calculated using a single data source, others require a combination of data sources. The calculation of indicators is logically split in separate workflows (see **[HOW TO IMPLEMENT WORKFLOWS](./src/)**).

Supplementary information regarding the dashboard can be 
found **[here](https://coronadashboard.rijksoverheid.nl/verantwoording)**.

