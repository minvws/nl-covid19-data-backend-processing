# **NL CORONAVIRUS DASHBOARD**

---

**<a style="color:red">NOTE! STILL WORKING ON IT.</a>**

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/minvws/nl-covid19-data-backend-processing/ci-cd?label=build&logo=github-actions&logoColor=white)](https://github.com/minvws/nl-covid19-data-backend-processing/blob/topic/redesign/.github/workflows/ci-cd.yml)
[![repo size](https://img.shields.io/github/repo-size/minvws/nl-covid19-data-backend-processing?logo=github)](https://github.com/minvws/nl-covid19-data-backend-processing)


The **[dashboard](https://coronadashboard.rijksoverheid.nl)** provides information on the breakout and prevalence of the *Coronavirus* in The Netherlands. It combines measured and modelled data from various sources to give a broad perspective on the subject. See **[documentation](docs/)** for more information.

## **TABLE OF CONTENTS**

---

1. **[Getting Started](#**getting-started**)**
2. **[Development Process](#**development-process**)**
3. **[Contributions](#**contributions**)**
4. **[Disclaimers](#**disclaimers**)**

## **Getting Started**

---

### MICROSOFT SQL SERVER 2019

A **[Microsoft SQL Server 2019](https://www.microsoft.com/en-us/evalcenter/evaluate-sql-server-2019)** is used to ingest and digest the various sources. A **[docker](https://docs.docker.com/engine/install/)** image can also be used if no on-premise or cloud solution is available (**[Microsoft](https://hub.docker.com/_/microsoft-mssql-server)**):

> Powershell

```powershell
docker run `
    -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=yourStrong(!)Password" `
    --restart unless-stopped `
    -p 1433:1433 `
    -d `
    mcr.microsoft.com/mssql/server:2019-latest
```

### DATATINO

To schedule and automate the ingestion and digestion of data, custom a application is used: **[Datatino Orchestrator](https://kpmg-nl@dev.azure.com/kpmg-nl/VWS-covid19-migration-project/_git/Datatino)** (publicly available soon). However the user could use a different schedule and automate solution (or manually).

> Powershell

```powershell
# Trigger a or multiple workflows

$body = @{
    flowType = 4
    dataflow = (
        1001,
        1002
    )
    protos = $null
    pipeLine = $null
    requestTime = "2021-12-31 00:00:00.0000000"
    issue = $null
};

$parameters = @{
    Method = "POST"
    Uri =  "https://<azure-function>.azurewebsites.net/api/a_flow_httpstart"
    Body = ($body | ConvertTo-Json) 
    ContentType = "application/json"
};

Invoke-RestMethod @parameters;
```

After the indicators are calculated, **[Datatino Protocols](https://kpmg-nl@dev.azure.com/kpmg-nl/VWS-covid19-migration-project/_git/Datatino)** (i.e. Proto, publicly available soon) are used to package the results in predefined and desired (human readable) JSON documents.

>Powershell

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

### CI/CD PIPELINES

**[Azure DevOps CI/CD Pipelines](../deploy)** or **[Github Actions](../.github/workflows/build-pipelines.yml)** can be used to build executable `Transact-SQL` (i.e. `T-SQL`) scripts and release these scripts to their respective environment (i.e. `Development`, `Acceptance` and `Production`).

When running into CI/CD issues (e.g. IP Address restrictions), use the following command to start listening for `Github Action` jobs with self-hosted runners - on a computer with the required premissions:

> Powershell

```powershell
$TAG="ghcr.io/minvws/corona-dashboard/github-runners:unstable"
$REPOSITORY_URL="https://github.com/minvws/nl-covid19-data-backend-processing"
$GITHUB_RUNNER_TOKEN="<token>"

docker run `
    -e GITHUB_RUNNER_TOKEN=$GITHUB_RUNNER_TOKEN `
    -e GITHUB_RUNNER_REPOSITORY_URL=$REPOSITORY_URL `
    --restart unless-stopped `
    -d `
    $TAG
```

|Name|Description|Defaults|
|--|--|--|
|`GITHUB_RUNNER_TOKEN`|Runner token provided by GitHub in the Actions page. These tokens are valid for a short period.|Required if `GITHUB_ACCESS_TOKEN` is not provided|
|`GITHUB_RUNNER_REPOSITORY_URL`|The runner will be linked to this repository URL||


## **DEVELOPMENT PROCESS**

---

The core team aims to define and calculate various related indicators which are ultimately presented on **[dashboard](https://coronadashboard.rijksoverheid.nl)**. Some indicators are calculated using a single data source, others require a combination of data sources. The calculation of indicators is logically split in separate workflows (see **[HOW TO IMPLEMENT WORKFLOWS](src/)**).

Supplementary information regarding the dashboard can be 
found here: **[link](https://coronadashboard.rijksoverheid.nl/verantwoording)**.

### **Running build-script.ps1 locally (with minikube)**
Since Docker Desktop is now a paid for product, running docker on windows requires some alternatives. One such alternative is making use of **[minikube](https://minikube.sigs.k8s.io/docs/start/)** for windows. It can be easily installed using winget:  
`winget install minikube`   
after which it is important that there is an available **[driver](https://minikube.sigs.k8s.io/docs/drivers/hyperv/)** in order to run it, hyperv is recommended; so simply enable the hyperv windows feature:  
`Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All`  
Install the docker-cli via the **[chocolatey](https://chocolatey.org/install)** package manager as follows:  
`choco install docker`  

The PowerShell scripts in use require PowerShell 7, so install this as well:  
`winget install --id Microsoft.Powershell --source winget`  

You might require some restarts of your console or computer in between these steps.

Then you can start minikube as follows:  
`minikube start --driver=hyperv`  
When minikube is started, you need to run the following command in your powershell console in order to be able to use docker commands directly:  
`& minikube -p minikube docker-env --shell powershell | Invoke-Expression`  
This is required in every instance of PowerShell that you wish to perform docker commands in such as `docker ps -a` 
To get the ip address that is used by your docker container you can run the follow command:  
`([System.Uri]$Env:DOCKER_HOST).Host`, which is necessary information for running the build-script.ps1

This is all that is required to run the build-script.ps1:
Go to the root of this project where this readme is also located and run the following command:  
`.\.github\workflows\scripts\build-script.ps1 -Hostname ([System.Uri]$Env:DOCKER_HOST).Host`  

#### **updating your datatino configuration automatically with the currently running docker container**
The previous section showed how to run the script to update the database automatically, but if you recreate your docker containers, the password and location of the MSSQL server can change. To automatically update there is another script called run-build-for-minikube.ps1 which will automatically update your .env and .database files of the datatino solution in all locations with the correct connection string.

Install the Az powerhsell module:  
`Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force -AllowClobber`  

Make sure your local Azure Storage (azurite) is running if your current .env file is configured to use it:  
`azurite --silent --location c:\azurite --debug c:\azurite\debug.log`  

Update the locations at the top of the `run-build-for-minikube.ps1` script and then run it. 

## **CONTRIBUTIONS**

---

The core team works directly from this open-source repository. If you want to make a contribution we recommend opening an issue first in order to avoid the situation where we already have your contribution staged or can't use your contribution due to certain causes.

## **DISCLAIMERS**

---

One can get in touch with the development team by joining the **[CODE For NL Slack](https://doemee.codefor.nl)**, channel: ***#coronadashboard***. Tamas Erkelens (from the Municipality of Amsterdam) is the main contact person for of the team. 

<a style="color:red">**NOTE!**</a> This is not the same development team that created the *NL Coronavirus Notification App*.