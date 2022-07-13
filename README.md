# **NL CORONAVIRUS DASHBOARD**

---

[![Build Status](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_apis/build/status/business-logic/nl-cdb-be-business-logic%20-%20CI?repoName=nl-cdb-be-business-logic)](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_build/latest?definitionId=9&repoName=nl-cdb-be-business-logic&branchName=topic%2FCOR-912_Couple-Variant-on-Variantcode)


The **[dashboard](https://coronadashboard.rijksoverheid.nl)** provides information on the breakout and prevalence of the *Coronavirus* in The Netherlands. It combines measured and modelled data from various sources to give a broad perspective on the subject. See **[documentation](docs/)** for more information.

## **TABLE OF CONTENTS**

---

1. **[Getting Started](#getting-started)**
2. **[Development Process](#development-process)**
3. **[Contributions](#contributions)**
4. **[Disclaimers](#disclaimers)**

## **Getting Started**

---

### **Relational Databases**

A **[Microsoft SQL Server 2019](https://www.microsoft.com/en-us/evalcenter/evaluate-sql-server-2019)** is used to ingest and digest the various sources. **[Docker](https://docs.docker.com/engine/install/)** images can also be used when on-premise or cloud solution are not available (**[Docker Hub](https://hub.docker.com/_/microsoft-mssql-server)**). 

By running the following command at the root of the project:

> Powershell

```pwsh
clear && . ./.devops/scripts/build-script.ps1 && rm -r *.sql
```

a SQL server with a database is created (**ONLY THE FIRST TIME**), which sequentially will be populated with all **[business logic](./src/)** from scratch **[link](./.devops/scripts/build-script.ps1)**.

### **Troubleshooting**

---

|Name|Description|Why?|
|--|--|--|
|`Peronal Access Token`|You might be promted to use a Personal Access Token (PAT), with a **Repository (read) scope**. This token is valid for a limited period and is used only when the SQL container is created.|During the creating of the SQL container initialize required database artifacts (e.g. `Schema`, `Stored Procedures` and `Views`) are created. The PAT enables the get these artifacts [**[link](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_git/nl-cdb-be-apis)**].|
|`minikube`|After installing and configuring `minikube`, run the following command to build the solution: `clear && ./.devops/scripts/run-build-for-minikube.ps1 && rm -r *.sql`.|When running into build issue on a Windows machine, an workaround with **[minikube](https://minikube.sigs.k8s.io/docs/start/)** can be used. |
|`Local database` |The build of the solution can be performed using `clear && ./.devops/scripts/build-script.ps1 -Hostname '<ip-address>' -Port '<port-number>' && rm -r *.sql`.|If an container engine is not available (with `Docker CLI`) on the hosting machine.|

<font color="red">**Every time the code is changed, run the script to locally build (i.e. execute) and validate the SQL script.**</font>

### **Extract Load Transform**

To schedule, and automate, the ingestion and digestion of the data, a custom application (i.e **[Datatino Orchestrator](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_git/nl-cdb-be-apis)**) in combination with **[PowerApp](https://powerapps.microsoft.com/en-us/)** are used. However the user could use a different schedule and automation solution (or manually), for example **[Azure Data Factory](https://docs.microsoft.com/en-us/azure/data-factory/introduction)** **[[link](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_git/nl-cdb-be-factory)]**.



After the indicators are calculated, **[Datatino Protocols](https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard/_git/nl-cdb-be-apis)** (i.e. Proto) are used to package the results in predefined and desired (human readable) JSON documents.

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

> Bash

```bash
# Create protos (i.e. JSON formatted documents) 

curl --location --request POST 'https://<azure-function>.azurewebsites.net/api/a_proto_zipprotos' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "protoPath": "datatino/test",
        "zipPath": "datatino/testzip",
        "zipFileName": "protos.zip",
        "refreshProtos": true
    }'
```
### **CI/CD PIPELINES**

**[Azure DevOps CI/CD Pipelines](./.devops)** can be used to build executable `Transact-SQL` (i.e. `T-SQL`) scripts and release these scripts to their respective environment (i.e. `Development`, `Acceptance` and `Production`).

When running into CI/CD issues (e.g. Ip Address restrictions), use the following command to start listening for `Azure DevOps` jobs with self-hosted agents - on a machine with the right permissions:

> Bash

```bash
# Set variables
TAG="local-agent"
DEVOPS_SERVER_INSTANCE_URL="https://dev.azure.com/VWSCoronaDashboard"
DEVOPS_AGENT_TOKEN="<Personal Access Token>"

# Create local image
CONTEXT_DIR="./.agents"
docker build -t $TAG -f "$CONTEXT_DIR/Dockerfile" $CONTEXT_DIR

# Run local image as container with the required PAT and URL.
docker run \
    -e DEVOPS_SERVER_INSTANCE_URL=$DEVOPS_SERVER_INSTANCE_URL \
    -e DEVOPS_AGENT_TOKEN=$DEVOPS_AGENT_TOKEN \
    --restart unless-stopped \
    -d \
    $TAG
```

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

See **[self-hosted agent container](./.agents)** for more information and **[Micosoft](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops)**.


## **DEVELOPMENT PROCESS**

---

The core team aims to define and calculate various related indicators which are ultimately presented on **[dashboard](https://coronadashboard.rijksoverheid.nl)**. Some indicators are calculated using a single data source, others require a combination of data sources. The calculation of indicators is logically split in separate workflows (see **[HOW TO IMPLEMENT WORKFLOWS](./src/)**).

Supplementary information regarding the dashboard can be 
found here: **[link](https://coronadashboard.rijksoverheid.nl/verantwoording)**.

## **CONTRIBUTIONS**

---

The core team works directly from this open-source repository. If you want to make a contribution we recommend opening an issue first in order to avoid the situation where we already have your contribution staged or can't use your contribution due to certain causes.

## **DISCLAIMERS**

---

One can get in touch with the development team by joining the **[CODE For NL Slack](https://doemee.codefor.nl)**, channel: ***#coronadashboard***. Tamas Erkelens (from the Municipality of Amsterdam) is the main contact person for of the team. 

<a style="color:red">**NOTE!**</a> This is not the same development team that created the *NL Coronavirus Notification App*.