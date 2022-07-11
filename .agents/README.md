> Terminal

```bash
docker run \
    -e DEVOPS_AGENT_REPOSITORY_URL="https://dev.azure.com/VWSCoronaDashboard/Corona Dashboard" \
    -e DEVOPS_AGENT_TOKEN="znzk43oamflp5dyq5tplnazuywlvk5d3pbihtwbeio3p6fe3ynqa" \
    test-agent 
```

> Powershell

```powershell
docker run test-agent `
    -e DEVOPS_URL="https://dev.azure.com/VWSCoronaDashboard/Corona%20Dashboard" `
    -e DEVOPS_TOKEN=<PAT>
```