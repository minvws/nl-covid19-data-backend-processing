# **NL CORONAVIRUS DASHBOARD**

---

[![Build Status](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_apis/build/status/business-logic/nl-cdb-be-business-logic%20-%20CI?repoName=nl-cdb-be-business-logic&label=Build)](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_build/latest?definitionId=9&repoName=nl-cdb-be-business-logic) [![Release Status](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_apis/build/status/business-logic/nl-cdb-be-business-logic%20-%20CD?repoName=nl-cdb-be-business-logic&label=Releases)](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_build/latest?definitionId=10&repoName=nl-cdb-be-business-logic)


The **[Corona Dashboard](https://coronadashboard.rijksoverheid.nl)** provides information on the breakout and prevalence of the *Coronavirus* in The Netherlands. It combines measured and modelled indicators from various sources to give a broad perspective on the subject. See **[documentation](docs/)** for more information. 

## **TABLE OF CONTENTS**
asd
---

1. **[Getting Started](#getting-started)**
2. **[Development Process](#development-process)**
3. **[Contributions](#contributions)**
4. **[Disclaimers](#disclaimers)**

## **Getting Started**

---

All calculations and data-manipulations (usually constrained to *one* specific workflow) are described in **Microsoft SQL** (i.e., MSSQL) scripts. By using ***Jupyter Notebooks*** - with a SQL kernel - the MSSQL logic can be grouped into a singular *Notebooks​* (i.e., `*.ipynb`) containing the complete code and (optional) documentation for *one* workflow.

### **Relational Databases**

A **[Microsoft SQL Server 2019](https://www.microsoft.com/en-us/evalcenter/evaluate-sql-server-2019)** is used to ingest and digest the various sources. **Container images** - using **[Docker](https://docs.docker.com/engine/install/)**, **[minikube](https://minikube.sigs.k8s.io/docs/start/)**, **[Podman](https://podman.io/getting-started/)** or Docker runtimes that support **[Docker CLI](https://community.chocolatey.org/packages/docker-cli)**) can be used used when on-premise or cloud solution are not available during development (**[Docker Hub](https://hub.docker.com/_/microsoft-mssql-server)**). 

By running the following command at the root of the project:

> Powershell

```powershell
clear && . "./.devops/scripts/build-script.ps1" && rm -r *.sql
```

a containerized MSSQL server with a database is created when the script is initialized for the first time, which sequentially will be populated with all **[Business Logic](./src/)** from scratch. For more information see **[Build Script](./.devops/scripts/build-script.ps1)**.

### **Troubleshooting**

---

|Name|Description|Why?|
|--|--|--|
|`PowerShell 7+`|Install the latest version of **[PowerShell](https://www.delftstack.com/howto/powershell/update-windows-powershell/)**.|Older version of PowerShell do not support chained commands (i.e., `&&`) and Null coalescing operators (i.e., `??`). 
|`Peronal Access Token`|You might be promted to use a Personal Access Token (PAT), with a **Repository (read) scope**. This token is valid for a limited period and is used only the creation of the MSSQL container. **[Learn more](https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows)**|During the creating of the MSSQL container it requires additional database artifacts (e.g. `Schema`, `Stored Procedures` and `Views`) that must be pre-created on to the database. The PAT allows the build script to get these artifacts from (yet) **[Datatino](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_git/nl-cdb-be-apis)**.|
|`minikube`|After installing and configuring `minikube`, run the following command to locally build the solution: `clear && . ./.devops/scripts/build-script-for-minikube.ps1 && rm -r *.sql`.|When running into build issue on a Windows machine, an workaround with **[minikube](https://minikube.sigs.k8s.io/docs/start/)** can be used. |
|`Local database` |The build of the solution can be performed using `clear && ./.devops/scripts/build-script.ps1 -Hostname '<ip-address>' -Port '<port-number>' && rm -r *.sql`.|If an **Container engine** is not available (with `Docker CLI`) on the hosting machine, use an existing MSSQL database.|

**<font color="red">NOTE!</font>** Every time the code has been modified, run the `Build Script` to locally build (i.e., execute) and validate the MSSQL scripts.

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

## **CONTRIBUTIONS**

---

The core team works directly from this open-source repository. If you want to make a contribution we recommend opening an issue first in order to avoid the situation where we already have your contribution staged or can't use your contribution due to certain causes.

## **DISCLAIMERS**

---

One can get in touch with the development team by joining the **[CODE For NL Slack](https://doemee.codefor.nl)**, channel: ***#coronadashboard***. Tamas Erkelens (from the Municipality of Amsterdam) is the main contact person for of the team. 

<a style="color:red">**NOTE!**</a> This is not the same development team that created the *NL Coronavirus Notification App*.