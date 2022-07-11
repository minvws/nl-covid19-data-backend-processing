> Terminal

```bash
docker run \
    -e DEVOPS_AGENT_REPOSITORY_URL="<URL>" \
    -e DEVOPS_AGENT_TOKEN="<PAT>" \
    test-agent 
```

> Powershell

```powershell
docker run test-agent `
    -e DEVOPS_URL="<URL>" `
    -e DEVOPS_TOKEN=<PAT>
```