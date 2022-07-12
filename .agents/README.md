# **CI/CD PIPELINES**

**[Azure DevOps CI/CD Pipelines](../.devops)** can be used to build executable `Transact-SQL` (i.e. `T-SQL`) scripts and release these scripts to their respective environment (i.e. `Development`, `Acceptance` and/or `Production`).

When running into CI/CD issues (e.g. Ip Address restrictions), use the following commands to start listening for `DevOps` jobs with self-hosted agents - on a computer or `Azure Container Instance` (i.e. ACR)  with the right permissions:

> Terminal

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
    -d `
    $TAG
```

|Name|Description|Defaults|
|--|--|--|
|`DEVOPS_AGENT_TOKEN`|Agent token provided by DevOps in the `Personal Access Token` (PAT) page with a **Agent Pools (read, manage) scope**. This token is valid for a limited period.|Required if `DEVOPS_AGENT_TOKEN_FILE` is not provided.|
|`DEVOPS_AGENT_REPOSITORY_URL`|The URL of the Azure DevOps or Azure DevOps Server instance.||
|`DEVOPS_AGENT_AGENT_NAME`|Agent name.|The container `hostname`|
|`DEVOPS_AGENT_POOL`|Agent pool name.|The default pool is `Default`|