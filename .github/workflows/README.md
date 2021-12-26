# **GITHUB ACTIONS**

---

Multiple `GitHub Actions` are used to **[release the Corona Dashboard](release-db.yml)** and/or **[register containers](register-containers.yml)**. 

Regarding the **[containers](../../.containers)**, an optional self-hosted runners packages (registered within **[GitHub Container Registry](https://github.blog/2020-09-01-introducing-github-container-registry/)**) can be used to run `GitHub Actions`. 

## **TABLE OF CONTENTS**

---

1. **[Release Corona Dashboard](#**release-corona-dashboard**)**
2. **[Register Containers](#**register-containers)**


## **BUILD AND RELEASE ACTIONS**

---

During the release, when a pull request has been approved on the `master/` branch, the build actions will convert all commited and modified `.ipynb` files into executable `.sql` scripts 

During the conversion, all `.sql` scripts will be validated within an `mcr.microsoft.com/mssql/server:2019-latest` container by executing the scripts on a blank database. 

```yml
env:
    GITHUB_WORKFLOWS: "./.github/workflows"

- name: 2 - Build MSSQL Artifacts
  run: |
    & "${{ env.GITHUB_WORKFLOWS }}/scripts/build-script.ps1" `
      -SourceDirectory "${{ github.workspace }}" `
      -ModifiedFiles "${{ needs.analyse.outputs.modified_scripts }}"
  shell: pwsh
```

Sequentually, the `.sql`, including the **[release script](scripts/release-script.ps1)** artifacts, will be archived for future releases.

```yml
- name: "3 - Copy Files: MSSQL Scripts"
  uses: actions/upload-artifact@v2.3.1
  with:
    name: mssql-artifacts
    path: "${{ github.workspace }}/*.sql"
    if-no-files-found: error # 'warn' or 'ignore' are also available, defaults to `warn`
    retention-days: 28

- name: "4 - Copy Files: Powershell Scripts"
  uses: actions/upload-artifact@v2.3.1
  with:
    name: pwsh-artifacts
    path: "${{ env.GITHUB_WORKFLOWS }}/scripts/"
    if-no-files-found: error # 'warn' or 'ignore' are also available, defaults to `warn`
    retention-days: 28
```

On the other hand, the **[release actions](release-pipeline.yml)** will retreive the archived artifacts and only executes the `.sql` scripts using `Invoke-Sqlcmd` which is part of the `SqlServer` Powershell module. 

```yml
- name: 5 - Migrate MSSQL Artifacts
  run: |
    & "${{ env.GITHUB_WORKSPACE }}/scripts/release-script.ps1" `
      -Server "${{ env.MSSQL_SERVER }}" `
      -Database "${{ env.MSSQL_DATABASE }}" `
      -SourceDirectory "${{ github.workspace }}/src" `
      -Username "${{ secrets.LOGIN_USERNAME }}" `
      -Password "${{ secrets.LOGIN_PASSWORD }}"
  shell: pwsh
```

## **REGISTER CONTAINERS**

---

While running the **[workflow](register-containers.yml)** a `Docker image` will be created and registered (i.e. **[ghcr.io/minvws/corona-dashboard/github-runners:unstable](../../..containers/Dockerfile)**) to enable the use of a containerized self-hosted runner. 

Please note that this is most likely a workaround when the `GitHub build-in runners` are restricted (e.g. IP restrictions) during a build or release action.

Use the following command to start listening for `GitHub Actions` within self-hosted runners:

> Powershell

```powershell
$TAG="ghcr.io/minvws/corona-dashboard/github-runners:unstable"
$REPOSITORY_URL="https://github.com/<github.owner>/<github.repository>"

docker run `
    -e RUNNER_TOKEN=$GITHUB_RUNNER_TOKEN `
    -e RUNNER_REPOSITORY_URL=$REPOSITORY_URL `
    --restart unless-stopped `
    -d `
    $TAG
```

|Name|Description|Defaults|
|--|--|--|
|`GITHUB_RUNNER_TOKEN`|Runner token provided by GitHub in the Actions page. These tokens are valid for a short period.|Required if `GITHUB_ACCESS_TOKEN` is not provided|
|`GITHUB_RUNNER_REPOSITORY_URL`|The runner will be linked to this repository URL||