# **HOW TO BUILD AND RELEASE IMPLEMENTATIONS**

---

Three separate ***GitHub Actions*** are used to build and release, respecitively, executable `.sql` scripts and an optional self-hosted runners packages (registered within **[GitHub Container Registry](https://github.blog/2020-09-01-introducing-github-container-registry/)**). The release pipeline will automatically be trigger when the build pipeline has successfully finished executing. 

## **TABLE OF CONTENTS**

---

1. **[Build Actions](#**build-actions**)**
2. **[Release Actions](#**release-actions**)**
3. **[Package Build Actions](#**package-build-actions)**


## **BUILD ACTIONS**

---

The **[build action](workflows/build-action.yml)** will convert all commited and modified `.ipynb` files into executable `.sql` scripts when a pull request has been approved (one the `master/` branch). 

During the conversion, all `.sql` scripts will be validated within an `mcr.microsoft.com/mssql/server:2019-latest` container by executing the scripts on a blank database. 

```yml
env:
    GITHUB_WORKFLOWS: "./.github/workflows"

- name: 2 - Build MSSQL Artifacts
  run: |
    & "${{ env.GITHUB_WORKFLOWS }}/scripts/build-script.ps1" `
      -SourceDirectory "${{ github.workspace }}" `
      -ModifiedFiles "${{ needs.analyse.outputs.modified_all }}"
  shell: pwsh
```

Sequentually, the `.sql`, including the **[release script](workflows/scripts/release-script.ps1)** artifacts, will be archived for future releases.

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

## **RELEASE ACTIONS**

---

On the other hand, the **[release pipeline](release-pipeline.yml)** will retreive the archived artifacts and only executes the `.sql` scripts using `Invoke-Sqlcmd` which is part of the `SqlServer` Powershell module. 

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

## **PACKAGE BUILD ACTIONS**

---

The **[package action](workflows/package-build-action.yml)** contains the instruction to create and register a `Docker image` (i.e. **[ghcr.io/minvws/corona-dashboard/github-runners:unstable](packages/Dockerfile)**) to enable the use of a self-hosted runner within a container. 

Please note that this is most likely a workaround when the `GitHub build-in runners` are restricted (e.g. IP restrictions) during a build or release action.

Use the following command to start listening for `Github Action` jobs within self-hosted runners:

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